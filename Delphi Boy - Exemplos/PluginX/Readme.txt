

  Plugin X versão 1.1 beta - 21/01/2004



[x] Descrição

    Projeto de comunicação entre uma DLL/Aplicação 
    e uma aplicação Servidor de Internet

[x] Funcionamento

    A biblioteca PluginX contém padrões de funções/tipos/constantes
    que são usados para comunicação entre a DLL(Plugin) e a aplicação
    Servidor.
    Uma DLL Plugin deve conter as funções básicas LoadPlugin,
    UnloadPlugin e OnExecute para que o Servidor chame essas
    funções quando forem necessárias.


* LoadPlugin/UnloadPlugin
-------------------------

* LoadPlugin
AppInfo       -> Dados que a aplicação preenche para mandar para o Plugin
PluginInfo    -> Dados que o Plugin preenche para retornar para a aplicação

A aplicação Servidor na inicialização carrega todas funções das
DLLs localizadas na subpasta plugins, ao carregar cada DLL ela
executa(se houver) a função LoadPlugin que tem como parâmetros
os dados da aplicação(TAppInfo) e do Plugin(TPluginInfo),
na finalização da aplicação a função UnloadPlugin é executada
que pode conter qualquer código que a DLL precise executar ao
ser liberada.


* OnExecute
-----------

Ao executar a função OnExecute mandando os dados recebidos pelo Servidor,
a DLL processa os dados e devolve o valor processado para o parâmetro
eReturn.

mWnd          -> Handle da janela principal da aplicação
eClientThread -> Ponteiro para o Thread socket do cliente
eCmd          -> Dados recebidos pelo servidor
eReturn       -> Dados retornados pela função
NoPause       -> Ainda que pode ser usado para avisar a DLL
                 que a aplicação não pode ser interrompida


* Como o Plugin se comunica com a aplicação
-------------------------------------------

Usando a API SendMessage(e não PostMessage) com a mensgem WM_COPYDATA.

SendMessage(HandleJanelaAplicacao, WM_COPYDATA, HandleDLL, Integer(@TCopyDataStruct));

- TCopyDataStruct:
    dwData: Número identificador da mensagem
    cbData: Tamanho em bytes dos dados passados em lpData
    lpData: Ponteiro para os dados a serem enviados
    * Em lpData os dados não devem ser qualquer tipo de Ponteiro(TObject, PChar..),
      recomendo usar sempre Array of Char ou String[255] ou records com variáveis
      desses tipos por exemplo
    * Em dwData são usados valores a seguir ou outros que você queira criar,
      para que a aplicação interprete:
       MSG_ERROR            - Ocorreu um erro
       APP_BROADCAST_WRITE  - Mandar texto para todos clientes
       APP_CLIENT_WRITE     - Mandar texto para um cliente
       APP_CLIENT_CLOSE     - Desconectar um cliente
       APP_CLIENT_GETCLIENT - Exibir informações de um cliente


* Como a aplicação captura e interpreta as mensagens
----------------------------------------------------

- declaração da procedure:
procedure RotinaCopyData(var msg: TWMCopyData); message WM_COPYDATA;

- código:
procedure TForm.RotinaCopyData(var msg: TWMCopyData);
begin
      //verifica identificador da mensagem recebida
      case msg.CopyDataStruct^.dwData of      
        APP_BROADCAST_WRITE : ...Código  
        APP_CLIENT_WRITE    : ...Código
        ...
      end;

    //Marca a menssagem como processada
    msg.Result := 1;
  end;
end;

 - TWMCopyData:
    Msg: Mensagem
    From: Handle de quem está enviando a mensagem WM_COPYDATA
    CopyDataStruct: Ponteiro para a estrutura TCopyDataStruct recebida
    Result: Valor retornado pela mensagem
    

[x] Comentários

    Comecei a desenvolver esse projeto a partir da idéia que tive para fazer
    um sistema de plugins para um IRCd feito em Delphi(http://ircdelphi.sourceforge.net/)
    onde poderiam ser implementados os Services ou qualquer tipo de interpretação de dados
    a partir de uma DLL. Esse é mais um exemplo a parte de como se comunicar com uma
    aplicação a partir de uma DLL ou outra aplicação. Ainda estou procurando por um método
    para que a aplicação possa se comunicar com uma DLL sem que seja por execução de funções
    contidas na DLL, se é que isso seja possível =) ..se for para se comunicar com outra
    aplicação seria só também usar SendMessage com WM_COPYDATA.


[x] Autor/Contato

    Glauber Almeida Dantas
    E-Mail: glauber@delphix.com.br
    Site: www.delphix.com.br
    IRC: #DelphiX - irc.brasnet.org
    ICQ: 125689417





EOF