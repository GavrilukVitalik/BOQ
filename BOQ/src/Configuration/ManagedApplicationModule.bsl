
Перем ЗадаватьВопросПриЗакрытии Экспорт;

Процедура ПриНачалеРаботыСистемы ()
	
	ЗадаватьВопросПриЗакрытии = Истина;
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы ( Отказ, ТекстПредупреждения )
	
	#Если ВебКлиент Тогда 
		ТекстПредупреждения = "Завершить работу с программой?"; 
	#Иначе
		Если ( ЗадаватьВопросПриЗакрытии ) Тогда
			Отказ = Истина;
			ТекстПредупреждения = "Завершить работу с программой?"; 
		КонецЕсли; 
	#КонецЕсли	
	
КонецПроцедуры