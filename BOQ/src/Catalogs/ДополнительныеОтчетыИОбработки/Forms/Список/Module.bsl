
&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере ( ИмяЭлемента, Настройки, Строки )
	
	заполнитьРазделы ( Строки );
	
КонецПроцедуры

&НаСервереБезКонтекста 
Процедура заполнитьРазделы ( Данные )
	
	мРазделы = Новый Массив ();
	Для Каждого строкаДС Из Данные Цикл
		мРазделы.Добавить ( строкаДС.Ключ );		
	КонецЦикла; 
	с = "
	|выбрать
	|	Ссылка как Ссылка, 
	|	представление ( Раздел ) как Раздел
	|из
	|	Справочник.ДополнительныеОтчетыИОбработки.Разделы
	|где
	|	Ссылка в ( &МассивРазделы )
	|упорядочить по
	|	Ссылка.Наименование 
	|итоги
	|по
	|	Ссылка 
	|";
	запрос = Новый Запрос ( с );
	запрос.УстановитьПараметр ( "МассивРазделы", мРазделы );
	результат = запрос.Выполнить ();
	выборкаИтоги = результат.Выбрать ( ОбходРезультатаЗапроса.ПоГруппировкам );
	Пока ( выборкаИтоги.Следующий () ) Цикл
		спрСсылка = выборкаИтоги.Ссылка;
		с = "";
		выборка = выборкаИтоги.Выбрать ( ОбходРезультатаЗапроса.Прямой );
		Пока выборка.Следующий () Цикл
			с = с + ? ( с = "", "", ", " ) + выборка.Раздел;			
		КонецЦикла;
		Данные [ спрСсылка ].Данные.Разделы = с;
	КонецЦикла;
	
КонецПроцедуры