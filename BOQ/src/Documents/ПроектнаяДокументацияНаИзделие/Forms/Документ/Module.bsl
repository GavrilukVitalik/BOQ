
&НаСервере
Процедура ПриСозданииНаСервере ( Отказ, СтандартнаяОбработка )
	
	Если ( Объект.Ссылка.Пустая () ) Тогда
		начальноеЗаполнение ();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура начальноеЗаполнение ()
	
	Объект.Автор = ПараметрыСеанса.ТекущийПользователь;
	ОбработкаМоделиВыполняется = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии ( Отказ )
	
	установитьДоступность ();
	
КонецПроцедуры

&НаКлиенте
Процедура установитьДоступность ()

	Элементы.ЗапуститьОбработку.Доступность = Не ОбработкаМоделиВыполняется;
	Элементы.ЗапуститьОбработку.Пометка = ОбработкаМоделиВыполняется;
	Элементы.ПрерватьОбработку.Доступность = ОбработкаМоделиВыполняется;
	
КонецПроцедуры

#Область Команды

&НаКлиенте
Процедура ЗагрузитьФайлRVT ( Команда )
	
	Если ( Объект.Ссылка.Пустая () ) Тогда
		Сообщения.ПредупреждениеПоказать ( "ОбъектНеЗаписан" );
	Иначе
		Если ( Объект.ФайлRVT = "" ) Тогда
			выборФайлаЗагрузкиRVT ();
		Иначе
			Сообщения.ВопросПоказать ( "УдалитьФайлПроектнойДокументации", , "ВопросУдалитьRVT", ЭтотОбъект );
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросУдалитьRVT ( Ответ, Парамы ) Экспорт
	
	Если ( Ответ = КодВозвратаДиалога.Да ) Тогда
		удалитьПрикрепленныйФайл ( Объект.Ссылка, Объект.ФайлRVT );
		расширение = РаботаСФайлами.ПолучитьРасширениеФайла ( Объект.ФайлRVT );
		имяФайла = СтрЗаменить ( Объект.ФайлRVT, расширение, "" );
		удалитьЗапись ( Объект.Ссылка, имяФайла, расширение );
		выборФайлаЗагрузкиRVT ();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура удалитьПрикрепленныйФайл ( Объект, ИмяФайла )
	
	папка = РегистрыСведений.Файлы.ПолучитьПапкуХранения ( Объект );
	путь = папка + ИмяФайла;
	УдалитьФайлы ( путь );
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура удалитьЗапись ( Объект, ИмяФайла, Расширение )
	
	РегистрыСведений.Файлы.УдалитьЗапись ( Объект, ИмяФайла, Расширение );
	
КонецПроцедуры	

&НаКлиенте
Процедура выборФайлаЗагрузкиRVT ()
	
	п = Новый Структура ();
	п.Вставить ( "Фильтр", Сообщения.ТекстПоИД ( "ФильтрRVT" ) );
	п.Вставить ( "МножественныйВыбор", Ложь );
	п.Вставить ( "Оповещение", Новый ОписаниеОповещения ( "ПослеЗагрузкиФайлаПроектнойДокументации", ЭтотОбъект ) );
	РаботаСФайлами.ВыбратьФайлы ( п );	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗагрузкиФайлаПроектнойДокументации ( Данные, Парамы ) Экспорт
	
	Если ( Данные <> Неопределено ) Тогда
		Если ( Данные.Файлы.Количество () > 0 ) Тогда
			файл = Данные.Файлы [ 0 ];
			присоединитьФайл ( Объект.Ссылка, файл );
			Объект.ФайлRVT = файл.Имя;
			Объект.НаименованиеДокументации = СтрЗаменить ( файл.Имя, файл.Расширение, "" );
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура присоединитьФайл ( Объект, Файлы )
	
	РегистрыСведений.Файлы.ПрисоединитьФайл ( Объект, Файлы ); 
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлRVT ( Команда )

	Если ( Объект.ФайлRVT = "" ) Тогда
		// код ...
	Иначе
		выборФайлаДляСохраненияRVT ();		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура выборФайлаДляСохраненияRVT ()
	
	данные = РаботаСФайлами.ПолучитьИмяФайлаРасширение ( Объект.ФайлRVT );
	адрес = получитьПрикрепленныйФайл ( Объект.Ссылка, данные.Имя, данные.Расширение );
	Если ( адрес = Неопределено ) Тогда
		Возврат;
	КонецЕсли;
	п = Новый Структура ();
	п.Вставить ( "Фильтр", Сообщения.ТекстПоИД ( "ФильтрRVT" ) );
	п.Вставить ( "Адрес", адрес );
	п.Вставить ( "МножественныйВыбор", Ложь );
	п.Вставить ( "ИмяФайла", Объект.ФайлRVT );
	п.Вставить ( "Имя", данные.Имя );
	п.Вставить ( "Расширение", данные.Расширение );
	п.Вставить ( "Оповещение", Новый ОписаниеОповещения ( "ПослеСохраненияRVT", ЭтотОбъект ) );
	РаботаСФайлами.СохранитьФайлы ( п );	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСохраненияRVT ( Данные, Парамы ) Экспорт
	
	Если ( Данные <> Неопределено ) Тогда
		// код ...
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция получитьПрикрепленныйФайл ( Объект, Имя, Расширение )
	
	Возврат РегистрыСведений.Файлы.ПоместитьФайлВХранилище ( Объект, Имя, Расширение );

КонецФункции

&НаКлиенте
Процедура СохранитьФайлSVF2 ( Команда )

	Если ( Объект.ФайлSVF = "" ) Тогда
		// код ...
	Иначе
		выборФайлаSVF ();		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура выборФайлаSVF ()
	
	данные = РаботаСФайлами.ПолучитьИмяФайлаРасширение ( Объект.ФайлSVF );
	адрес = получитьПрикрепленныйФайл ( Объект.Ссылка, данные.Имя, данные.Расширение );
	Если ( адрес = Неопределено ) Тогда
		Возврат;
	КонецЕсли;
	п = Новый Структура ();
	п.Вставить ( "Фильтр", Сообщения.ТекстПоИД ( "ФильтрSVF" ) );
	п.Вставить ( "Адрес", адрес );
	п.Вставить ( "МножественныйВыбор", Ложь );
	п.Вставить ( "ИмяФайла", Объект.ФайлSVF );
	п.Вставить ( "Имя", данные.Имя );
	п.Вставить ( "Расширение", данные.Расширение );
	п.Вставить ( "Оповещение", Новый ОписаниеОповещения ( "ПослеСохраненияSVF", ЭтотОбъект ) );
	РаботаСФайлами.СохранитьФайлы ( п );	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСохраненияSVF ( Данные, Парамы ) Экспорт
	
	Если ( Данные <> Неопределено ) Тогда
		// код ...
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОбработку ( Команда )

	Если ( Объект.ФайлRVT = "" ) Тогда
		Сообщения.СообщениеВывести ( "НеЗагруженФайлRVT" );
	Иначе
		проверитьФайлRVTФТП ();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура проверитьФайлRVTФТП ()
	
	доступ = параметрыПодключенияФТП ( Объект.УчетнаяЗаписьBIM );
	файлЕсть = ФТП.ПроверитьНаличиеФайла ( доступ, Объект.ФайлRVT );
	Если ( файлЕсть ) Тогда
		Сообщения.ВопросПоказать ( "ЗапуститьОбработкуМодели", , "ВопросЗапуститьОбработку", ЭтотОбъект );	
	Иначе
		Сообщения.СообщениеВывести ( "ФайлRVTНаФТПНеНайден" );
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗапуститьОбработку ( Ответ, Парамы ) Экспорт
	
	Если ( Ответ = КодВозвратаДиалога.Да ) Тогда
		ОбработкаМоделиВыполняется = Истина;
		установитьДоступность ();
		Объект.ИмяКонтейнера = получитьИмяКонтейнера ( Объект.ФайлRVT );
		п = Новый Структура ();
		п.Вставить ( "Документация", Объект.Ссылка );
		п.Вставить ( "ИмяФайла", Объект.ФайлRVT );
		п.Вставить ( "УчетнаяЗапись", Объект.УчетнаяЗаписьBIM );
		п.Вставить ( "Ключ", ( Объект.Номер + "_" + Объект.ФайлRVT ) );
		п.Вставить ( "ИмяКонтейнера", Объект.ИмяКонтейнера );
		п.Вставить ( "Номер", Объект.Номер );
		запуститьЗаданиеОбработки ( п );
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьОбработку ( Команда )

	Сообщения.ВопросПоказать ( "ПрерватьОбработкуМодели", , "ВопросПрерватьОбработку", ЭтотОбъект );	

КонецПроцедуры

&НаКлиенте
Процедура ВопросПрерватьОбработку ( Ответ, Парамы ) Экспорт
	
	Если ( Ответ = КодВозвратаДиалога.Да ) Тогда
		ОбработкаМоделиВыполняется = Ложь;
		установитьДоступность ();
		Сообщить ( "ТЕСТ", СтатусСообщения.Обычное );  
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРезультатыОбработки ( Команда )

	Сообщения.ВопросПоказать ( "УдалитьРезультатыОбработкиМодели", , "ВопросУдалитьРезультатыОбработки", ЭтотОбъект );

КонецПроцедуры

&НаКлиенте
Процедура ВопросУдалитьРезультатыОбработки ( Ответ, Парамы ) Экспорт
	
	Если ( Ответ = КодВозвратаДиалога.Да ) Тогда
		Сообщить ( "ТЕСТ", СтатусСообщения.Обычное );  
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьRVTНаFTP ( Команда )
	
	Если ( Объект.ФайлRVT = "" ) Тогда
		Сообщения.СообщениеВывести ( "НеЗагруженФайлRVT" );
	Иначе
		Сообщения.ВопросПоказать ( "ВыгрузитьФайлRVTНаФТП", , "ВопросВыгрузитьФайлRVTНаFTPОбработку", ЭтотОбъект );		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросВыгрузитьФайлRVTНаFTPОбработку ( Ответ, Парамы ) Экспорт
	
	Если ( Ответ = КодВозвратаДиалога.Да ) Тогда
		полноеИмяФайла = получитьПапкуХраненияФайлов ( Объект.Ссылка ) + Объект.ФайлRVT;
		доступ = параметрыПодключенияФТП ( Объект.УчетнаяЗаписьBIM );
		ФТП.ВыгрузитьФайлНаФТП ( доступ, полноеИмяФайла, Объект.ФайлRVT );
    	Сообщения.СообщениеВывести ( "ФайлRVTВыгруженНаФТП" );
	КонецЕсли;
			
КонецПроцедуры

&НаСервереБезКонтекста 
Функция параметрыПодключенияФТП ( УчетнаяЗапись ) Экспорт

	Возврат ФТП.ПараметрыПодключенияBIMСервер ( УчетнаяЗапись );

КонецФункции

&НаСервереБезКонтекста
Функция получитьПапкуХраненияФайлов ( Ссылка )
	
	Возврат РегистрыСведений.Файлы.ПолучитьПапкуХранения ( Ссылка );
			
КонецФункции

&НаСервереБезКонтекста
Функция получитьИмяКонтейнера ( ИмяФайла )
	
	Возврат МоделиBIM.ПолучитьИмяКонтейнера ( ИмяФайла );
	
КонецФункции

&НаСервереБезКонтекста
Процедура запуститьЗаданиеОбработки ( Параметры )
	
	//м = Новый Массив ();
	//м.Добавить ( Параметры );
	//задание = ФоновыеЗадания.Выполнить ( "МоделиBIM.НачатьОбработкуМодели", м, Параметры.Ключ, Параметры.Ключ );
	МоделиBIM.НачатьОбработкуМодели ( Параметры );
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьURN ( Команда )
	
	обновитьДанныеОчереди ();
	
КонецПроцедуры

&НаКлиенте
Процедура обновитьДанныеОчереди ()
	
	данные = получитьИдентификаторМодели ( Объект.Ссылка );
	Объект.ИдентификаторМодели = данные.ИдентификаторМодели;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция получитьИдентификаторМодели ( Ссылка )
	
	Возврат РегистрыСведений.ОчередиОбработкиДокументации.ПолучитьРесурсы ( Ссылка );

КонецФункции

&НаКлиенте
Процедура ПроверитьСтатусОбработки ( Команда )
	
	п = Новый Структура ();
	п.Вставить ( "УчетнаяЗапись", Объект.УчетнаяЗаписьBIM );
	п.Вставить ( "ИмяКонтейнера", Объект.ИмяКонтейнера );
	ответ = проверитьСтатусОбработкиСервер ( п );
	Если ( ответ.ID <> 0 ) Тогда
		Объект.МодельID = ответ.ID;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция проверитьСтатусОбработкиСервер ( Параметры )
	
	Возврат МоделиBIM.ПроверитьСтатус ( Параметры );
	
КонецФункции

#КонецОбласти