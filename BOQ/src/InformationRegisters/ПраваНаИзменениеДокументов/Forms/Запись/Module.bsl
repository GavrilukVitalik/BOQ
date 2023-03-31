
&НаКлиенте 
Перем СписокДокументов;

&НаСервере
Процедура ПриСозданииНаСервере ( Отказ, СтандартнаяОбработка )
	
	ТолькоПросмотр = получитьДоступность ();
	Если ( ТолькоПросмотр ) Тогда
		Возврат;
	КонецЕсли;
	Если ( НЕ ЗначениеЗаполнено ( Параметры.Ключ ) ) Тогда
		Запись.МетодРасчетаОграничения = Перечисления.МетодРасчетаОграниченийДоступаКДокументам.Период;
		Запись.Действие = Перечисления.ДействияРазрешитьЗапретить.Разрешить;
		Запись.ДатаНачала = ТекущаяДата ();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере 
Функция получитьДоступность ()
	
	Возврат НЕ ( РольДоступна ( "ПолныеПрава" ) ); 

КонецФункции

&НаКлиенте
Процедура ТипДокументаНачалоВыбора ( Элемент, ДанныеВыбора, СтандартнаяОбработка )
	
	ПоказатьВыборИзСписка ( Новый ОписаниеОповещения ( "ОбработатьВыборИзСписка", ЭтотОбъект ), СписокДокументов, Элемент );
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборИзСписка ( Результат, ДополнительныеПараметры ) Экспорт 
	
	Если ( Результат <> Неопределено ) Тогда
		ТипДокумента = Результат.Представление;
		Запись.ТипДокумента = Результат.Значение;
	КонецЕсли; 
	                                              
КонецПроцедуры 

&НаСервереБезКонтекста
Функция получитьСписокДокументов ()
	
	список = Новый СписокЗначений;
	Для Каждого докМетадата Из Метаданные.Документы Цикл
		список.Добавить ( докМетадата.Имя, докМетадата.Синоним );		
	КонецЦикла;
	Возврат список;
	
КонецФункции 

&НаКлиенте
Процедура МетодРасчетаОграниченияПриИзменении ( Элемент )
	
	ОбновитьЭлементыФормы ();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии ( Отказ )
	
	СписокДокументов = получитьСписокДокументов ();
	ОбновитьЭлементыФормы ();
	Если ( Запись.ТипДокумента <> "" ) Тогда
		ТипДокумента = СписокДокументов.НайтиПоЗначению ( Запись.ТипДокумента ).Представление; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЭлементыФормы ()
	
	методПериод = ( Запись.МетодРасчетаОграничения = ПредопределенноеЗначение ( "Перечисление.МетодРасчетаОграниченийДоступаКДокументам.Период" ) );
	Элементы.ДатаНачала.Видимость = методПериод;
	Элементы.ДатаОкончания.Видимость = методПериод;
	элементы.КоличествоДней.Видимость = НЕ методПериод;
	
КонецПроцедуры 

&НаКлиенте
Процедура ТипДокументаОчистка ( Элемент, СтандартнаяОбработка )
	
	Запись.ТипДокумента = "";
	
КонецПроцедуры