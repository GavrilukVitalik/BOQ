
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаданиеИД = Параметры.ИдентификаторЗадания;
	ФоновоеЗадание = Обработки.КонсольЗаданий.Создать().ПолучитьОбъектФоновогоЗадания(ЗаданиеИД);
	Если ФоновоеЗадание <> Неопределено Тогда
		ИмяМетода = ФоновоеЗадание.ИмяМетода;
		Наименование = ФоновоеЗадание.Наименование;
		Ключ = ФоновоеЗадание.Ключ;
	Иначе
		//Ключ = Новый УникальныйИдентификатор;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ВыполнитьФоновоеЗадание();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьФоновоеЗадание()
	
	Попытка	
	    //@skip-warning
	    ФоновоеЗадание = ФоновыеЗадания.Выполнить(ИмяМетода,, Ключ, Наименование);
	Исключение
		Сообщения.СообщениеВывести ( "ОписаниеОшибки", Новый Структура ( "Ошибка", ОписаниеОшибки () ) );
	КонецПопытки;
	
КонецПроцедуры