
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Автообновление = Параметры.Автообновление;
	ПериодАвтообновления = Параметры.ПериодАвтообновления;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Результат = Новый Структура("Автообновление, ПериодАвтообновления", Автообновление, ПериодАвтообновления);
	Закрыть(Результат);
	
КонецПроцедуры