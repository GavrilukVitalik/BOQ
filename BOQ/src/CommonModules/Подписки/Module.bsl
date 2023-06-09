
Процедура ПолучениеПолейПредставления ( Источник, Поля, СтандартнаяОбработка ) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить ( "Наименование" );
	код = ПараметрыСеанса.КодЯзыка;
	Если ( код <> "ru" ) Тогда
		Поля.Добавить ( "Наименование" + код );		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПолучениеПредставления ( Источник, Данные, Представление, СтандартнаяОбработка ) Экспорт 
	
	код = ПараметрыСеанса.КодЯзыка;
	Если ( код = "ru" ) Тогда
		 // код ...
	ИначеЕсли ( Данные [ "Наименование" + код ] = "" ) Тогда
		// код ...
	Иначе
		СтандартнаяОбработка = Ложь;
		Представление = Данные [ "Наименование" + код ];
	КонецЕсли; 
	
КонецПроцедуры