
Функция СоздатьFTPСоединение ( Параметры ) Экспорт

	Возврат Новый FTPСоединение ( Параметры.Путь, Параметры.Порт, Параметры.Логин, Параметры.Пароль );
	
КонецФункции

&НаСервере 
Функция ПараметрыПодключенияBIMСервер ( УчетнаяЗапись ) Экспорт

	данные = Запросы.ПолучитьРеквизиты ( УчетнаяЗапись, "FTP_Логин, FTP_Пароль,FTP_Порт, FTP_Путь" );
	п = Новый Структура ();
	п.Вставить ( "Логин", данные.FTP_Логин );
	п.Вставить ( "Пароль", данные.FTP_Пароль );
	п.Вставить ( "Порт", данные.FTP_Порт );
	п.Вставить ( "Путь", данные.FTP_Путь );
	Возврат п;

КонецФункции

Процедура ВыгрузитьФайлНаФТП ( Доступ, Источник, Назначение, Каталог = "/" ) Экспорт
	
	соединение = СоздатьFTPСоединение ( Доступ );
	соединение.УстановитьТекущийКаталог  ( Каталог );
	соединение.Записать ( Источник, Назначение );
	
КонецПроцедуры

Функция ПроверитьНаличиеФайла ( Доступ, ИмяФайла, Каталог = "/", Маска = "*.*", ИскатьВПодкаталогах = Ложь ) Экспорт
	
	результат = Ложь;
	соединение = СоздатьFTPСоединение ( Доступ );
	соединение.УстановитьТекущийКаталог  ( Каталог );
	файлыФТП = соединение.НайтиФайлы ( Каталог, Маска, ИскатьВПодкаталогах );
	Для Каждого файлФТП Из файлыФТП Цикл
		Если ( файлФТП.Имя = ИмяФайла ) Тогда
			результат = Истина;
			Прервать;
		КонецЕсли;	
	КонецЦикла;
	Возврат результат;

КонецФункции