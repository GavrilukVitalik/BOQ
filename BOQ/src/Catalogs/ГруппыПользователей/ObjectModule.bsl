
Процедура ПередЗаписью ( Отказ )
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	убратьДубли ();

КонецПроцедуры

Процедура ПриЗаписи ( Отказ )
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура убратьДубли ()
	
	тз = Состав.Выгрузить ();
	тз.Свернуть ( "Пользователь" );
	Состав.Загрузить ( тз );
	
КонецПроцедуры