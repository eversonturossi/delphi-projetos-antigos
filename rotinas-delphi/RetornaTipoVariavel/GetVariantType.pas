function GetVariantType(const v: variant): string;
//
// Retorna de que tipo é a variavel especificada
//
begin
case TVarData(v).vType of
     varEmpty:     result := 'Empty';
     varNull:      result := 'Null';
     varSmallInt:  result := 'SmallInt';
     varInteger:   result := 'Integer';
     varSingle:    result := 'Single';
     varDouble:    result := 'Double';
     varCurrency:  result := 'Currency';
     varDate:      result := 'Date';
     varOleStr:    result := 'OleStr';
     varDispatch:  result := 'Dispatch';
     varError:     result := 'Error';
     varBoolean:   result := 'Boolean';
     varVariant:   result := 'Variant';
     varUnknown:   result := 'Unknown';
     varByte:      result := 'Byte';
     varString:    result := 'String';
     varTypeMask:  result := 'TypeMask';
     varArray:     result := 'Array';
     varByRef:     result := 'ByRef';
end;
end;
