
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Регламентные = РегламентныеЗадания.ПолучитьРегламентныеЗадания();
	Для Каждого РегламентноеЗадание из Регламентные Цикл
		Элементы.Регламентное.СписокВыбора.Добавить(РегламентноеЗадание.Метаданные.Имя, РегламентноеЗадание);
	КонецЦикла;
	Активно = Ложь;
	Завершено = Ложь;
	ЗавершеноАварийно = Ложь;
	Отменено = Ложь;
	Если Параметры.Отбор <> Неопределено Тогда
		Для Каждого Свойство из Параметры.Отбор Цикл
			Если Свойство.Ключ = "Начало" Тогда
				Начало = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "Конец" Тогда
				Конец = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "Ключ" Тогда
				Ключ = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "Наименование" Тогда
				Наименование = Свойство.Значение;	
			ИначеЕсли Свойство.Ключ = "ИмяМетода" Тогда
				Метод = Свойство.Значение;	
			ИначеЕсли Свойство.Ключ = "Ключ" Тогда
				Ключ = Свойство.Значение;	
			ИначеЕсли Свойство.Ключ = "РегламентноеЗадание" Тогда
				Регламентное = Свойство.Значение;
				СписокВыбора = Элементы.Регламентное.СписокВыбора;
				Для Каждого ЭлементСписка из СписокВыбора Цикл
					Если ЭлементСписка.Значение.УникальныйИдентификатор = Регламентное.УникальныйИдентификатор ТОгда
						Регламентное = ЭлементСписка.Значение;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			ИначеЕсли Свойство.Ключ = "Состояние" Тогда
				Для Каждого СостояниеЗадания из Свойство.Значение Цикл
					Если СостояниеЗадания = СостояниеФоновогоЗадания.Активно Тогда
						Активно = Истина;
					ИначеЕсли СостояниеЗадания = СостояниеФоновогоЗадания.Завершено Тогда
						Завершено = Истина;	
					ИначеЕсли СостояниеЗадания = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
						ЗавершеноАварийно = Истина;		
					ИначеЕсли СостояниеЗадания = СостояниеФоновогоЗадания.Отменено Тогда
						Отменено = Истина;		
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;		
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Отбор = ПолучитьОтбор();
	Закрыть(Отбор);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОтбор ()
	
	Отбор = Новый Структура;
	Если Не ПустаяДата(Начало) Тогда
		Отбор.Вставить("Начало", Начало);
	КонецЕсли;
	Если Не ПустаяДата(Конец) Тогда
		Отбор.Вставить("Конец", Конец);
	КонецЕсли;
	Если Не ПустаяСтрока(Ключ) Тогда
		Отбор.Вставить("Ключ", Ключ);
	КонецЕсли;
	Если Не ПустаяСтрока(Наименование) Тогда
		Отбор.Вставить("Наименование", Наименование);
	КонецЕсли;
	Если Не ПустаяСтрока(Метод) Тогда
		Отбор.Вставить("ИмяМетода", Метод);
	КонецЕсли;
	Если Регламентное <> "" Тогда
		Отбор.Вставить("РегламентноеЗадание", Регламентное);
	КонецЕсли;
	Массив = Новый Массив;
	Если Активно Тогда
		Массив.Добавить(СостояниеФоновогоЗадания.Активно);
	КонецЕсли;
	Если Завершено Тогда
		Массив.Добавить(СостояниеФоновогоЗадания.Завершено);
	КонецЕсли;
	Если ЗавершеноАварийно Тогда
		Массив.Добавить(СостояниеФоновогоЗадания.ЗавершеноАварийно);
	КонецЕсли;
	Если Отменено Тогда
		Массив.Добавить(СостояниеФоновогоЗадания.Отменено);
	КонецЕсли;
	Если Массив.Количество() > 0 ТОгда
		Отбор.Вставить("Состояние", Массив);
	КонецЕсли;
	Возврат Отбор;
	
КонецФункции

&НаСервере
Функция ПустаяДата(Дата)
	
	Если Дата = '00010101' Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

