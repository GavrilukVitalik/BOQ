
#Область ОбработкаМоделей

Процедура НачатьОбработкуМодели ( Параметры ) Экспорт
	
	Сообщения.СообщениеВывести ( "НачатаОбработкаФайлаRVT", Новый Структура ( "Дата", ТекущаяДата () ) );
	серверОбработки = получитьСерверОбработки ( Параметры.УчетнаяЗапись );
	ответ = стартЗагрузкиМодели ( серверОбработки, Параметры ); 	
	п = Новый Структура ();
	п.Вставить ( "Статус", ответ.Статус );
	п.Вставить ( "ИдентификаторМодели", ответ.ИдентификаторМодели );
	Сообщения.СообщениеВывести ( "СтатусЗагрузкиМоделиURN", п );
	Если ( ответ.ИдентификаторМодели = "" ) Тогда
		статус = Перечисления.СтатусыОбработкиДокументации.Ошибка;
	Иначе
		статус = Перечисления.СтатусыОбработкиДокументации.Трансляция;
	КонецЕсли;
	РегистрыСведений.ОчередиОбработкиДокументации.ЗаписатьСтатусОбработки ( Параметры.Документация, ответ.ИдентификаторМодели, статус );

КонецПроцедуры

Функция получитьСерверОбработки ( УчетнаяЗапись )
	
	м = Новый Массив ();
	м.Добавить ( "СерверОбработкиАдрес" );
	м.Добавить ( "СерверОбработкиПорт" );
	п = Запросы.ПолучитьРеквизиты ( УчетнаяЗапись, м );
	с = СтрШаблон ( "http://%1:%2", п.СерверОбработкиАдрес, СтрЗаменить ( п.СерверОбработкиПорт, " ", "" ) );  
	Возврат с;
	
КонецФункции

Функция стартЗагрузкиМодели ( Адрес, Параметры )
	
	имяФайла = Параметры.ИмяФайла;
	п = Новый Структура ( "Статус, ИдентификаторМодели", "<Не выполнено>", "" );
	с = СтрШаблон ( "%1/begin_process?bucket_key=%2&filename=%3", Адрес, Параметры.ИмяКонтейнера, ИмяФайла );
	Если Прав ( имяФайла, 3 ) = "zip" Тогда
		с = СтрШаблон ( "%1&root_filename=%2", с, СтрЗаменить ( имяФайла, "zip", "rvt" ) );
	КонецЕсли;
	ответ = ВыполнитьHttpЗапрос ( с );
	данные = Преобразования.ДанныеИзJSON ( ответ.ОтветСервера );
	Если ( данные <> Неопределено ) Тогда
		Если ( данные [ "status" ] <> 200 ) Тогда
			п.Статус = Сообщения.СообщениеВывести ( "ОшибкаОбработкиRVT", Новый Структура ( "Ошибка", данные [ "details" ] ) );
		Иначе
			п.Статус = данные.status;
			п.ИдентификаторМодели = данные.URN;
		КонецЕсли;
	КонецЕсли;
	Возврат п;
	
КонецФункции

Функция ПроверитьСтатус ( Параметры ) Экспорт

	п = Новый Структура ();
	п.Вставить ( "Статус", Перечисления.СтатусыОбработкиДокументации.Ошибка );
	п.Вставить ( "ID", 0 );
	п.Вставить ( "Ошибка", Ложь );
	п.Вставить ( "Описание", "" );
	серверОбработки = получитьСерверОбработки ( Параметры.УчетнаяЗапись );
	с = СтрШаблон ( "%1/check_process_status?bucket_key=%2", серверОбработки, Параметры.ИмяКорзины );
	ответ = ВыполнитьHttpЗапрос ( с );
	обработатьОтветПроверкиСтатуса ( п, ответ.ОтветСервера );
	Возврат п;

КонецФункции

Процедура обработатьОтветПроверкиСтатуса ( Параметры, ОтветСервера )
	
	Попытка
		данные = Преобразования.ДанныеИзJSON ( ОтветСервера );
		инфо = данные [ "info" ] ;
		Если ЗначениеЗаполнено ( данные [ "error" ] ) Тогда
			ошибкаПроверкиСтатуса ( Параметры, данные [ "error" ] );
		Иначе
			Если ( данные [ "status" ] ) Тогда
				Параметры.Статус = Перечисления.СтатусыОбработкиДокументации.Завершена;
				Если ЗначениеЗаполнено ( данные [ "model_id" ] ) Тогда
					Параметры.ID = данные [ "model_id" ];
				КонецЕсли;	
			ИначеЕсли Не ЗначениеЗаполнено ( инфо ) Тогда
				Параметры.Статус = Перечисления.СтатусыОбработкиДокументации.Ошибка;
			ИначеЕсли НРег ( инфо [ "Translation status" ] = "success complete" ) Тогда
				Параметры.Статус = Перечисления.СтатусыОбработкиДокументации.СохранениеБД;
			Иначе	
				Параметры.Статус = Перечисления.СтатусыОбработкиДокументации.Трансляция;
			КонецЕсли;	
			Если ЗначениеЗаполнено ( инфо ) Тогда
				п = Новый Структура ();
				п.Вставить ( "СтатусОбработки", Параметры.Статус );
				п.Вставить ( "СтатусТрансляции", инфо [ "Translation status" ] );
				п.Вставить ( "СтатусСохранение", инфо [ "Save status" ] );
				Параметры.Описание = Сообщения.ТекстПоИД ( "ОписаниеТрансляцииМодели", п );
			КонецЕсли;	
		КонецЕсли;	
	Исключение
		// код ...		
	КонецПопытки;	
	
КонецПроцедуры

Процедура ошибкаПроверкиСтатуса ( Параметры, ОписаниеОшибки )
	
	Параметры.Ошибка = Истина;
	Параметры.Описание = Сообщения.ТекстПоИД ( "ОшибкаПроверкиСтатуса", Новый Структура ( "Описание", данныеСервисаВСтроку ( ОписаниеОшибки ) ) );
	Параметры.Статус = Перечисления.СтатусыОбработкиДокументации.Ошибка;	
	
КонецПроцедуры

Функция данныеСервисаВСтроку ( ОписаниеОшибки )  
	
	с = "";	
	Если ТипЗнч ( ОписаниеОшибки ) = Тип ( "Массив" ) Тогда
		Для Каждого запись Из ОписаниеОшибки Цикл  
			новаяЗапись = данныеСервисаВСтроку ( запись );
			с = СтрШаблон ( "%1%2%3", с, ? ( с = "", "", Символы.ПС ), новаяЗапись );
		КонецЦикла;	
	Иначе
		с = СокрЛП ( ОписаниеОшибки );
	КонецЕсли;	
	Возврат с;
	
КонецФункции

Функция ТранслироватьМодель ( Параметры ) Экспорт
	
	текст = Сообщения.ТекстПоИД ( "НеВыполнено" );
	серверОбработки = получитьСерверОбработки ( Параметры.УчетнаяЗапись );
	с = СтрШаблон ( "%1/translate_file?urn=%2&check_only=%3&long_polling=%4", серверОбработки, Параметры.ИдентификаторМодели, ? ( Параметры.Проверка, "true", "false" ), ? ( Параметры.Опрос, "true", "false" ) );
	ответ = ВыполнитьHttpЗапрос ( с );
	Если ( Не ответ.Успех ) Тогда
		Сообщения.СообщениеВывести ( "ОшибкаЗапроса" );
	Иначе
		данные = Преобразования.ДанныеИзJSON ( ответ.ОтветСервера );
		Если ( данные <> Неопределено ) Тогда                       
			п = Новый Структура ();
			п.Вставить ( "Процент", данные [ "translate"] );
			п.Вставить ( "Статус", данные [ "translate_status" ] ); 
			текст = Сообщения.ТекстПоИД ( "ПроцентТрансляцииМодели", п );
		КонецЕсли; 
	КонецЕсли;	
	Возврат текст;

КонецФункции

Функция ПрерватьОбработкуМодели ( Параметры ) Экспорт
	
	п = Новый Структура ();
	п.Вставить ( "Успех", Ложь );
	п.Вставить ( "Описание", "" );
	серверОбработки = получитьСерверОбработки ( Параметры.УчетнаяЗапись );
	с = СтрШаблон ( "%1/kill_process?bucket_key=%2", серверОбработки, Параметры.ИмяКонтейнера );
	ответ = ВыполнитьHttpЗапрос ( с );
	Если ( Не ответ.Успех ) Тогда
		Сообщения.СообщениеВывести ( "ОшибкаЗапроса" );
	Иначе
		данные = Преобразования.ДанныеИзJSON ( ответ.ОтветСервера );
		Если ( данные <> Неопределено ) Тогда
			Если ( данные [ "status" ] ) Тогда
				п.Успех = Истина;
			ИначеЕсли ( данные [ "error" ] <> "" ) Тогда
				п.Описание = Сообщения.ТекстПоИД ( "ОшибкиПрерыванияОбработкиМодели", Новый Структура ( "Ошибка", данные [ "error" ] ) );
			Иначе
				// код ...
			КонецЕсли;			
		КонецЕсли; 
	КонецЕсли;	
	Возврат п;

КонецФункции

Функция РасшифроватьURNСервер ( ИдентификаторМодели ) Экспорт
	
	ответ = Новый Структура ();
	ответ.Вставить ( "Успех", Ложь );
	ответ.Вставить ( "ИмяКорзины", "" );
	ответ.Вставить ( "ИмяФайла", "" );
	Если Прав ( ИдентификаторМодели, 2 ) = "==" Тогда
		суффикс = "";
	ИначеЕсли Прав ( ИдентификаторМодели, 1 )= "=" Тогда
		суффикс = "=";
	Иначе
		суффикс = "==";
	КонецЕсли;	
	данные = Base64Значение ( ИдентификаторМодели + суффикс );
	Если ( данные <> Неопределено ) Тогда
		чтение = Новый ЧтениеДанных ( данные );
		текст = чтение.ПрочитатьСтроку ();
		чтение.Закрыть ();
		текст = СтрЗаменить ( текст, "/", ":" );
		текст = СтрЗаменить ( текст, ":", Символы.ПС );
		Если ( СтрЧислоСтрок ( текст ) > 4 ) Тогда
			ответ.Успех = Истина;
			ответ.ИмяКорзины = СтрПолучитьСтроку ( текст, 4 );
			ответ.ИмяФайла = СтрПолучитьСтроку ( текст, 5 );
		КонецЕсли;		
	КонецЕсли;	
	Возврат ответ;
	
КонецФункции

Функция ПолучитьИмяКонтейнера ( ИмяФайла ) Экспорт
	
	имя = СокрЛП ( ИмяФайла );
	имя = СтрЗаменить ( имя, ".rvt", "" );
	имя = СтрЗаменить ( имя, ".", "" );
	имя = СтрЗаменить ( имя, "_", "" );
	имя = СтрЗаменить ( имя, "#", "" );
	имя = СтрЗаменить ( имя, "-", "" );
	имя = Лев ( имя, 10 );
	имя = НРег ( имя );
	генератор = Новый ГенераторСлучайныхЧисел ();
	номер = генератор.СлучайноеЧисло ( 10000, 99999 );
	имя = СтрШаблон ( "%1%2", имя, номер );
	имя = СтрЗаменить ( имя, " ", "" );
	Возврат имя;
	
КонецФункции

Функция ВыполнитьHttpЗапрос ( Текст )
	
	п = Неопределено;	
	Попытка
		http = Новый COMОбъект ( "WinHttp.WinHttpRequest.5.1" );
		http.SetTimeouts ( 5000, 0, 0, 0 ); // 5000 - таймаут опроса, 0 - таймаут запроса
		http.Option ( 2, "utf-8" );
		http.Open ( "GET", Текст );
		http.Send ( "" ); // тело пустое
		http.WaitForResponse ();
		п = Новый Структура ();
		п.Вставить ( "Успех", Ложь );
		п.Вставить ( "ОтветСервера", http.ResponseText );
		п.Вставить ( "СтатусОтвета", http.Status );
		п.Вставить ( "СтатусОтветаТекст", http.StatusText );
		п.Вставить ( "ЗаголовкиОтвета", http.GetAllResponseHeaders () );	
		http = Неопределено;
	Исключение	
		// код ...
	КонецПопытки;	
	Возврат п;
	
КонецФункции

#КонецОбласти	
		
#Область ВнешниеИсточникиДанных

Функция ПолучитьМассивИсточников () Экспорт
	
	м = Новый Массив ();
	Для Каждого мета Из Метаданные.ВнешниеИсточникиДанных Цикл
		м.Добавить ( мета.Имя );
	КонецЦикла;
	Возврат м;
	
КонецФункции

Функция ПодключитьКВншИстДанных ( Ссылка ) Экспорт
	
	реквизиты = Запросы.ПолучитьРеквизиты ( Ссылка, "ИмяВнешнегоИсточника" );
	имяВнешнегоИсточника = реквизиты.ИмяВнешнегоИсточника;
	менеджер = ВнешниеИсточникиДанных [ имяВнешнегоИсточника ];
	состояние = менеджер.ПолучитьСостояние ();
	Если Состояние = СостояниеВнешнегоИсточникаДанных.Подключен Тогда
		Возврат Истина;
	КонецЕсли;	
	п = ПараметрыПодключения ( Ссылка );	
	соединение = менеджер.ПолучитьОбщиеПараметрыСоединения ();
	соединение.АутентификацияСтандартная = Не п.АутентификацияОС;
	соединение.АутентификацияОС = п.АутентификацияОС;
	соединение.ИмяПользователя = п.Логин;
	соединение.Пароль = п.Пароль;
	соединение.СтрокаСоединения = п.СтрокаПодключения;
	соединение.СУБД = п.ТипСУБД;
	ответ = Ложь;
	Попытка
		менеджер.УстановитьОбщиеПараметрыСоединения ( соединение );
		менеджер.УстановитьПараметрыСоединенияПользователя ( ИмяПользователя (), соединение );
		менеджер.УстановитьПараметрыСоединенияСеанса ( соединение );
		менеджер.УстановитьСоединение ();
		ответ = Истина;
	Исключение
		ответ = Ложь;
	КонецПопытки;	
	Возврат ответ;
	
КонецФункции

Функция ПараметрыПодключения ( Ссылка )  Экспорт
	
	с = "
	|выбрать
	|	Сервер как Сервер,
	|	Логин как Логин,
	|	Пароль как Пароль,
	|	ИмяВнешнейБД как ИмяВнешнейБД,
	|	АутентификацияОС как АутентификацияОС,
	|	представление ( ТипСУБД ) как ТипСУБД,
	|	СтрокаПодключения как СтрокаПодключения
	|из Справочник.ПодключенияВншИстДанных
	|где Ссылка = &Ссылка
	|";
	запрос = Новый Запрос ();
	запрос.Текст = с;
	запрос.УстановитьПараметр ( "Ссылка", Ссылка );
	результат = Запрос.Выполнить ();
	Если результат.Пустой () Тогда
		Возврат Неопределено;
	Иначе
		выборка = Результат.Выбрать();
		выборка.Следующий ();
		п = Новый Структура ();
		Для Каждого колонка Из результат.Колонки Цикл
			п.Вставить ( колонка.Имя, выборка [ колонка.Имя ] );			
		КонецЦикла;
		Возврат п;
	КонецЕсли;
	
КонецФункции

#КонецОбласти