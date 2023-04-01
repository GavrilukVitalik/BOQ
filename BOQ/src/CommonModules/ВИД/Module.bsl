
Функция ПолучитьМассивИсточников () Экспорт
	
	м = Новый Массив ();
	Для Каждого мета Из Метаданные.ВнешниеИсточникиДанных Цикл
		м.Добавить ( мета.Имя );
	КонецЦикла;
	Возврат м;
	
КонецФункции

Функция ПодключитьКВИД ( Ссылка ) Экспорт
	
	имяВнешнегоИсточника = Запросы.ПолучитьРеквизиты ( Ссылка, "ИмяВнешнегоИсточника" );
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
	соединение.СУБД = СокрЛП (п.ТипСУБД );
	ответ = Ложь;
	Попытка
		менеджер.УстановитьОбщиеПараметрыСоединения ( соединение);
		менеджер.УстановитьПараметрыСоединенияПользователя ( ИмяПользователя (), соединение );
		менеджер.УстановитьПараметрыСоединенияСеанса ( соединение );
		менеджер.УстановитьСоединение();
		ответ = Истина;
	Исключение
		ответ = Ложь;
	КонецПопытки;	
	Возврат ответ;
	
КонецФункции

Функция ПараметрыПодключения ( Ссылка )  Экспорт
	
	с = "
	|выбрать
	|	Сервер КАК Сервер,
	|	Логин КАК Логин,
	|	Пароль КАК Пароль,
	|	ИмяВнешнейБД КАК ИмяВнешнейБД,
	|	АутентификацияОС КАК АутентификацияОС,
	|	ТипСУБД КАК ТипСУБД,
	|	СтрокаПодключения КАК СтрокаПодключения
	|из Справочник.ПодключенияВИД
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
			п.Вставить ( колонка, выборка [ колонка ] );			
		КонецЦикла;
		Возврат п;
	КонецЕсли;
	
КонецФункции