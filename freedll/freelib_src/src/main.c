/*
 * FreeLib
 * 
 * Copyright (c) 2005 by eraser
 */

#include <windows.h>
#include <tlhelp32.h>
#include <stdio.h>
#include <aclapi.h>
#include <tchar.h>
#include <stdlib.h>

#if defined (_DEBUG)
	#define TRACE(str)	OutputDebugString(str)
#else
	#define TRACE(str)
#endif

#if !defined (SID_REVISION)
	#define SID_REVISION (1) 
#endif

BOOL enable_privilege(LPCTSTR szPrivilege);
BOOL adjust_dacl(HANDLE h, DWORD dwDesiredAccess); 
BOOL enable_token_privilege(HANDLE htok, LPCTSTR szPrivilege, TOKEN_PRIVILEGES *tpOld);
HANDLE adv_open_process(DWORD pid, DWORD dwAccessRights);
BOOL kill_process(DWORD pid);

BOOL get_process_list(LPCTSTR szLibrary);
BOOL list_process_modules(DWORD dwPID, LPCTSTR szProcessExeFile, LPCTSTR szLibrary);

char HelpText[] = 
"%s - release library utility - (c) 2005 by eraser (eraser@senior.cz)\n\n"
"Syntax: %s.exe [library_name.dll]\n\n";

void __defaultTrapHandler(int code) 
{ 
	abort(); 
} 

int main(int argc, char *argv[])
{
	if (argc < 2)
	{
		printf(HelpText, *argv, *argv);

		return 1;
	}
	
	get_process_list(*(argv + 1));

	return 0;
}

BOOL get_process_list(LPCTSTR szLibrary)
{
	HANDLE hProcessSnap;
	HANDLE hProcess;
	PROCESSENTRY32 pe32;
	DWORD dwPriorityClass;

	hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

	if (hProcessSnap == INVALID_HANDLE_VALUE)
	{
		TRACE("CreateToolhelp32Snapshot (of processes)");

		return (FALSE);
	}

	pe32.dwSize = sizeof(PROCESSENTRY32);

	if (!Process32First(hProcessSnap, &pe32))
	{
		TRACE("Process32First");
		CloseHandle(hProcessSnap);
		
		return (FALSE);
	}

	do
	{
		dwPriorityClass = 0;
		hProcess = adv_open_process(pe32.th32ProcessID, PROCESS_ALL_ACCESS);

		if (hProcess == NULL)
		{
			TRACE("OpenProcess");
		}
		else
		{
			dwPriorityClass = GetPriorityClass(hProcess);

			if (!dwPriorityClass)
			{
				TRACE("GetPriorityClass");
			}

			CloseHandle(hProcess);
		}

		list_process_modules(pe32.th32ProcessID, pe32.szExeFile, szLibrary);

	} while (Process32Next(hProcessSnap, &pe32));

	CloseHandle(hProcessSnap);

	return (TRUE);
}

BOOL list_process_modules(DWORD dwPID, LPCTSTR szProcessExeFile, LPCTSTR szLibrary)
{
	HANDLE hModuleSnap = INVALID_HANDLE_VALUE;
	MODULEENTRY32 me32;

	enable_privilege(SE_DEBUG_NAME);
	hModuleSnap = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, dwPID);

	if (hModuleSnap == (HANDLE) - 1)
	{
		TRACE("CreateToolhelp32Snapshot() failed!");
		TRACE(szProcessExeFile);

		return (FALSE);
	}

	me32.dwSize = sizeof(MODULEENTRY32);

	if (!Module32First (hModuleSnap, &me32))
	{
		TRACE("Module32First");
		CloseHandle(hModuleSnap);

		return (FALSE);
	}

	do
	{
		if (!lstrcmpi(szLibrary, me32.szModule))
		{
			printf("\nPROCESS: [%d] %s \t MODULE: %s", dwPID, szProcessExeFile, me32.szModule);
			printf(kill_process(dwPID) ? " terminated!" : " termination failed!");
		}

	} while (Module32Next(hModuleSnap, &me32));

	CloseHandle(hModuleSnap);

	return (TRUE);
}

BOOL enable_privilege(LPCTSTR szPrivilege)
{
	BOOL bReturn = FALSE;
	HANDLE hToken;
	TOKEN_PRIVILEGES tpOld;

	if (!OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY | TOKEN_ADJUST_PRIVILEGES, &hToken))
	{
		TRACE("enable_privilege");

		return(FALSE);
	}

	bReturn = (enable_token_privilege(hToken, szPrivilege, &tpOld));
	CloseHandle(hToken);

	return (bReturn);
}


BOOL adjust_dacl(HANDLE h, DWORD dwDesiredAccess)
{
	SID world = { SID_REVISION, 1, SECURITY_WORLD_SID_AUTHORITY, 0 };

	EXPLICIT_ACCESS ea =
	{
		0,
			SET_ACCESS,
			NO_INHERITANCE,
		{
			0, NO_MULTIPLE_TRUSTEE,
				TRUSTEE_IS_SID,
				TRUSTEE_IS_USER,
				0
		}
	};

	ACL* pdacl = 0;
	DWORD err = SetEntriesInAcl(1, &ea, 0, &pdacl);

	ea.grfAccessPermissions = dwDesiredAccess;
	ea.Trustee.ptstrName = (LPTSTR)(&world);

	if (err == ERROR_SUCCESS)
	{
		err = SetSecurityInfo(h, SE_KERNEL_OBJECT, DACL_SECURITY_INFORMATION, 0, 0, pdacl, 0);
		LocalFree(pdacl);

		return (err == ERROR_SUCCESS);
	}
	else
	{
		TRACE("adjust_dacl");

		return(FALSE);
	}
}

BOOL enable_token_privilege(HANDLE htok, LPCTSTR szPrivilege, TOKEN_PRIVILEGES *tpOld)
{
	TOKEN_PRIVILEGES tp;
	tp.PrivilegeCount = 1;
	tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

	if (LookupPrivilegeValue(0, szPrivilege, &tp.Privileges[0].Luid))
	{
		DWORD cbOld = sizeof (*tpOld);

		if (AdjustTokenPrivileges(htok, FALSE, &tp, cbOld, tpOld, &cbOld))
		{
			return (ERROR_NOT_ALL_ASSIGNED != GetLastError());
		}
		else
		{
			TRACE("enable_token_privilege");

			return (FALSE);
		}
	}
	else
	{
		TRACE("enable_token_privilege");

		return (FALSE);
	}
}


HANDLE adv_open_process(DWORD pid, DWORD dwAccessRights)
{
	HANDLE hProcess = OpenProcess(dwAccessRights, FALSE, pid);

	if (hProcess == NULL)
	{
		HANDLE hpWriteDAC = OpenProcess(WRITE_DAC, FALSE, pid);

		if (hpWriteDAC == NULL)
		{
			HANDLE htok;
			TOKEN_PRIVILEGES tpOld;

			if (!OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY | TOKEN_ADJUST_PRIVILEGES, &htok))
			{
				return(FALSE);
			}

			if (enable_token_privilege(htok, SE_TAKE_OWNERSHIP_NAME, &tpOld))
			{
				HANDLE hpWriteOwner = OpenProcess(WRITE_OWNER, FALSE, pid);

				if (hpWriteOwner != NULL)
				{
					BYTE buf[512];
					DWORD cb = sizeof buf;

					if (GetTokenInformation(htok, TokenUser, buf, cb, &cb))
					{
						DWORD err = SetSecurityInfo(hpWriteOwner, SE_KERNEL_OBJECT, OWNER_SECURITY_INFORMATION, ((TOKEN_USER *)(buf))->User.Sid, 0, 0, 0);
						
						if (err == ERROR_SUCCESS)
						{
							if (!DuplicateHandle(GetCurrentProcess(), hpWriteOwner, GetCurrentProcess(), &hpWriteDAC, WRITE_DAC, FALSE, 0))
							{
								hpWriteDAC = NULL;
							}
						}
					}

					CloseHandle(hpWriteOwner);
				}

				AdjustTokenPrivileges(htok, FALSE, &tpOld, 0, 0, 0);
			}

			CloseHandle(htok);
		}

		if (hpWriteDAC)
		{
			adjust_dacl(hpWriteDAC, dwAccessRights);

			if (!DuplicateHandle(GetCurrentProcess(), hpWriteDAC, GetCurrentProcess(), &hProcess, dwAccessRights, FALSE, 0))
			{
				hProcess = NULL;
			}

			CloseHandle(hpWriteDAC);
		}
	}

	return (hProcess);
}

BOOL kill_process(DWORD pid)
{
	HANDLE hp = adv_open_process(pid, PROCESS_TERMINATE);

	if (hp != NULL)
	{
		BOOL bRet = TerminateProcess(hp, 1);
		CloseHandle(hp);

		return (bRet);
	}

	return (FALSE);
}
