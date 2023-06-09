
&НаСервере
Процедура ПриСозданииНаСервере ( Отказ, СтандартнаяОбработка )
	
	Если ( Объект.Ссылка.Пустая () И Объект.Родитель.Ссылка = Справочники.ГруппыПользователей.ВсеПользователи ) Тогда
		Объект.Родитель = Справочники.ГруппыПользователей.ПустаяСсылка ();
	КонецЕсли;
	Если Объект.Ссылка = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		Элементы.Наименование.Доступность = Ложь;
		Элементы.Родитель.Доступность = Ложь;
		Элементы.СоставПодобрать.Доступность = Ложь;
		Элементы.Состав.Доступность = Ложь;
		Элементы.Комментарий.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи ( ПараметрыЗаписи )
	
	Оповестить ( "ЗаписьГруппыПользователей", Новый Структура, Объект.Ссылка );
	
КонецПроцедуры

&НаКлиенте
Процедура РодительНачалоВыбора ( Элемент, ДанныеВыбора, СтандартнаяОбработка )
	
	СтандартнаяОбработка = Ложь;
	п = Новый Структура ();
	п.Вставить ( "РежимВыбора", Истина );
	п.Вставить ( "ВыборРодителя" );
	ОткрытьФорму ( "Справочник.ГруппыПользователей.Форма.Выбор", п, Элементы.Родитель );
	
КонецПроцедуры

&НаКлиенте
Процедура СоставОбработкаВыбора ( Элемент, ВыбранноеЗначение, СтандартнаяОбработка )
	
	Если ТипЗнч ( ВыбранноеЗначение ) = Тип ( "Массив" ) Тогда
		Для Каждого Значение Из ВыбранноеЗначение Цикл
			обработкаВыбораПользователя ( Значение );
		КонецЦикла;
	Иначе
		обработкаВыбораПользователя ( ВыбранноеЗначение );
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПользователей ( Команда )
	
	п = Новый Структура;
	п.Вставить ( "РежимВыбора", Истина );
	п.Вставить ( "ЗакрыватьПриВыборе", Ложь );
	ОткрытьФорму ( "Справочник.Пользователи.Форма.Выбор", п, Элементы.Состав );

КонецПроцедуры

&НаКлиенте
Процедура обработкаВыбораПользователя ( ВыбранноеЗначение )
	
	Если ТипЗнч ( ВыбранноеЗначение ) = Тип ( "СправочникСсылка.Пользователи" ) Тогда
		Если Объект.Состав.НайтиСтроки ( Новый Структура ( "Пользователь", ВыбранноеЗначение ) ).Количество () = 0 Тогда
			Объект.Состав.Добавить ().Пользователь = ВыбранноеЗначение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры