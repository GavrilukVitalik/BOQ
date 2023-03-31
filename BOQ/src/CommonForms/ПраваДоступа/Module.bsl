
&НаСервере
Процедура ПриСозданииНаСервере ( Отказ, СтандартнаяОбработка )
	
	Если ( НЕ ЗначениеЗаполнено ( Параметры.Пользователь ) ) Тогда
		Отказ = Истина;	
	КонецЕсли;
	ПоказатьПодсистемы = Истина;
	ПоказатьТолькоВыбранные = Истина;
	заполнитьДеревоРоли ();
	добавитьОформление ();
	установитьОформление ();
	установитьПараметрыСписка ();
	Заголовок = Сообщения.ТекстПоИД ( "ФормаПраваДоступа", Новый Структура ( "Пользователь", Параметры.Пользователь ) );
	
КонецПроцедуры

&НаСервере
Процедура заполнитьДеревоРоли ()
	
	ветви = ДеревоРоли.ПолучитьЭлементы ();
	ветви.Очистить ();
	мРоли = ДоступСервер.ПолучитьРолиПользователя ( Параметры.Пользователь );
	заполнитьДеревоПодсистемы ( ветви, Метаданные.Подсистемы, мРоли );
	
КонецПроцедуры

&НаСервере
Процедура заполнитьДеревоПодсистемы ( Ветви, Подсистемы, ВыбранныеРоли )
	
	Для Каждого подсистема Из Подсистемы Цикл
		ветвь = Ветви.Добавить ();
		ветвь.Пометка = Ложь;
		ветвь.Синоним = ? ( подсистема.Синоним = "", подсистема.Имя, подсистема.Синоним );
		ветвь.НомерКартинки = 5; 
		ветвь.Имя = подсистема.Имя;
		ветвь.ЭтоРоль = Ложь;
		заполнитьДеревоПодсистемы ( ветвь.ПолучитьЭлементы (), подсистема.Подсистемы, ВыбранныеРоли );
		Для каждого роль Из Метаданные.Роли Цикл
			Если подсистема.Состав.Содержит ( Роль ) Тогда
				ветвьРоль = ветвь.ПолучитьЭлементы ().Добавить ();
				ветвьРоль.Пометка = ( ВыбранныеРоли.Найти ( роль.Имя ) <> Неопределено );
				ветвьРоль.Синоним = ? ( роль.Синоним = "", роль.Имя, роль.Синоним );
				ветвьРоль.НомерКартинки = 6; 
				ветвьРоль.Имя = роль.Имя;
				ветвьРоль.ЭтоРоль = Истина;
				Если ( ветвьРоль.Пометка ) Тогда
					заполнитьПометкуРодителя ( ветвь, Истина );
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура заполнитьПометкуРодителя ( Ветвь, Значение )
	
	Ветвь.Пометка = Значение;
	родитель = Ветвь.ПолучитьРодителя ();
	Если ( родитель <> Неопределено ) Тогда
		заполнитьПометкуРодителя ( родитель, Значение );
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура добавитьОформление ()
	
	УсловноеОформление.Элементы.Очистить ();
	добавитьОформлениеПометка ();
	добавитьОформлениеЭтоРоль ();
	
КонецПроцедуры

&НаСервере
Процедура добавитьОформлениеПометка ()
	
	уо = УсловноеОформление.Элементы.Добавить ();
	уо.Оформление.УстановитьЗначениеПараметра ( "Видимость", Ложь );
	отбор = уо.Отбор.Элементы.Добавить( Тип ( "ЭлементОтбораКомпоновкиДанных" ) );
	отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных ( "ДеревоРоли.Пометка" );
	отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;   
	отбор.ПравоеЗначение = Ложь;   
	отбор.Использование = Истина;
	полеУО = уо.Поля.Элементы.Добавить ();     
	полеУО.Поле = Новый ПолеКомпоновкиДанных ( "ДеревоРолиПометка" );
	полеУО.Использование = Истина;
	полеУО = уо.Поля.Элементы.Добавить ();     
	полеУО.Поле = Новый ПолеКомпоновкиДанных ( "ДеревоРолиСиноним" );
	полеУО.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура добавитьОформлениеЭтоРоль ()
	
	уо = УсловноеОформление.Элементы.Добавить ();
	уо.Оформление.УстановитьЗначениеПараметра ( "Видимость", Ложь );
	отбор = уо.Отбор.Элементы.Добавить( Тип ( "ЭлементОтбораКомпоновкиДанных" ) );
	отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных ( "ДеревоРоли.ЭтоРоль" );
	отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;   
	отбор.ПравоеЗначение = Ложь;   
	отбор.Использование = Истина;
	полеУО = уо.Поля.Элементы.Добавить ();     
	полеУО.Поле = Новый ПолеКомпоновкиДанных ( "ДеревоРолиПометка" );
	полеУО.Использование = Истина;
	полеУО = уо.Поля.Элементы.Добавить ();     
	полеУО.Поле = Новый ПолеКомпоновкиДанных ( "ДеревоРолиСиноним" );
	полеУО.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура установитьОформление ()
	
	// условное оформление для формы уже установлено
	УсловноеОформление.Элементы [ 0 ].Использование = ПоказатьТолькоВыбранные;
	УсловноеОформление.Элементы [ 1 ].Использование = НЕ ПоказатьПодсистемы;
	
КонецПроцедуры

&НаСервере
Процедура установитьПараметрыСписка ()
	
	СписокГруппыДоступа.Параметры.УстановитьЗначениеПараметра ( "Пользователь", Параметры.Пользователь );
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии ( Отказ )
	
	обновитьГруппы ();
	развернутьДеревоРоли ();
	
КонецПроцедуры

&НаКлиенте
Процедура обновитьГруппы ()
	
	Элементы.СписокГруппыДоступа.Обновить ();	
	
КонецПроцедуры

&НаКлиенте
Процедура развернутьДеревоРоли ()
	
	Для каждого ветвь Из ДеревоРоли.ПолучитьЭлементы () Цикл
        Элементы.ДеревоРоли.Развернуть ( ветвь.ПолучитьИдентификатор (), Истина );
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВГруппу ( Команда )
	
	п = Новый Структура ();
	п.Вставить ( "РежимВыбора", Истина );
	п.Вставить ( "МножественныйВыбор", Ложь );
	оповещение = Новый ОписаниеОповещения ( "ПослеВыбораГруппыДоступа", ЭтотОбъект );	
	ОткрытьФорму ( "Справочник.ГруппыДоступа.Форма.Выбор", п, ЭтаФорма, , , , оповещение );
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораГруппыДоступа ( ВыбранноеЗначение, Парамы ) Экспорт
	
	Если ( ВыбранноеЗначение <> Неопределено ) Тогда
		включитьПользователяВГруппы ( Параметры.Пользователь, ВыбранноеЗначение );
		Оповестить ( "ЗаписьГруппыДоступа", Новый Структура (), ВыбранноеЗначение );
		обновитьГруппы ();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура включитьПользователяВГруппы ( Пользователь, ГруппаДоступа )
	
	ДоступСервер.ВключитьПользователяВГруппы ( Пользователь, ГруппаДоступа );	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьИзГруппы ( Команда )
	
	группы = Элементы.СписокГруппыДоступа.ВыделенныеСтроки;
	Если ( группы.Количество () > 0 ) Тогда
		п = Новый Структура ();
		п.Вставить ( "Пользователь", Параметры.Пользователь );
		Сообщения.ВопросПоказать ( "ИсключитьПользователяИзГруппыДоступа", п, "ВопросИсключитьИзГруппы", ЭтотОбъект, Новый Структура ( "ГруппаДоступа", группы [ 0 ] ) );	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросИсключитьИзГруппы ( Ответ, Парамы ) Экспорт
	
	Если ( Ответ = КодВозвратаДиалога.Да ) Тогда
		исключитьПользователяИзГрупп ( Параметры.Пользователь, Парамы.ГруппаДоступа );
		Оповестить ( "ЗаписьГруппыДоступа", Новый Структура (), Парамы.ГруппаДоступа );
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура исключитьПользователяИзГрупп ( Пользователь, ГруппыДоступа )
	
	ДоступСервер.ИсключитьПользователяИзГрупп ( Пользователь, ГруппыДоступа );	
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьГруппу ( Команда )

	данные = Элементы.СписокГруппыДоступа.ТекущиеДанные;
	Если ( данные <> Неопределено ) Тогда
		п = Новый Структура ();
		п.Вставить ( "Ключ", данные.Ссылка );
		ОткрытьФорму ( "Справочник.ГруппыДоступа.Форма.Элемент", п, ЭтаФорма ); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения ( ИмяСобытия, Параметр, Источник )
	
	событие = ВРег ( ИмяСобытия ); 
	Если событие = ВРег ( "ЗаписьГруппыДоступа" ) ИЛИ событие = ВРег ( "ЗаписьПрофилиГруппДоступа" ) Тогда
		заполнитьДеревоРоли ();
		Элементы.СписокГруппыДоступа.Обновить ();
		развернутьДеревоРоли ();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьПодсистемы ( Команда )
	
	ПоказатьПодсистемы = НЕ ПоказатьПодсистемы;
	Элементы.ПоказатьПодсистемы.Пометка = ПоказатьПодсистемы;
	установитьОформление ();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьТолькоВыбранные ( Команда )
	
	ПоказатьТолькоВыбранные = НЕ ПоказатьТолькоВыбранные;
	Элементы.ПоказатьТолькоВыбранные.Пометка = ПоказатьТолькоВыбранные;
	установитьОформление ();
	
КонецПроцедуры