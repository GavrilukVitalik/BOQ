
&НаСервере
Процедура ПриСозданииНаСервере ( Отказ, СтандартнаяОбработка )
	
	установитьЗначенияПараметров ();
	сформироватьЗаголовок ();
		
КонецПроцедуры

&НаСервере
Процедура установитьЗначенияПараметров ()
	
	Список.Параметры.УстановитьЗначениеПараметра ( "Раздел", Параметры.Раздел );
	Список.Параметры.УстановитьЗначениеПараметра ( "ОбработкаОтчет", Параметры.ОбработкаОтчет );
	Список.Параметры.УстановитьЗначениеПараметра ( "ТекущийПользователь", ПараметрыСеанса.ТекущийПользователь );		
	
КонецПроцедуры

&НаСервере
Процедура сформироватьЗаголовок ()
	
	Если ( Параметры.ОбработкаОтчет = ПредопределенноеЗначение ( "Перечисление.ОбработкаОтчет.Обработка" ) ) Тогда
		Заголовок = Сообщения.ТекстПоИД ( "ОбработкиПоРазделу", Новый Структура ( "Раздел", Параметры.Раздел ) );
	ИначеЕсли ( Параметры.ОбработкаОтчет = ПредопределенноеЗначение ( "Перечисление.ОбработкаОтчет.Отчет" ) ) Тогда
		Заголовок = Сообщения.ТекстПоИД ( "ОбработкиПоОтчету", Новый Структура ( "Раздел", Параметры.Раздел ) );
	КонецЕсли; 
	
КонецПроцедуры 

&НаКлиенте
Процедура СписокВыбор ( Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка )
	
	СтандартнаяОбработка = Ложь;
	текущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ( текущаяСтрока <> Неопределено ) Тогда
		форма = подключитьОтчетОбработку ( текущаяСтрока );
		Если ( форма = "" ) Тогда
			Возврат;
		КонецЕсли; 
		п = Новый Структура ();
		ОткрытьФорму ( форма + ".Форма", п, ЭтаФорма, , , , , РежимОткрытияОкнаФормы.Независимый );
		Закрыть ();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция подключитьОтчетОбработку ( Данные )
	
	Возврат РаботаСФайлами.ПодключитьВнешнююОбработкуОтчет ( Данные );

КонецФункции