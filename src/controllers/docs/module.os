#Использовать "../../model"

Перем ИдентификаторСекции;

Функция Index() Экспорт
	
	ИмяСтраницыПредставления = "index-content";
	
	ПараметрыСтраницы = УправлениеКонтентом.ПолучитьПараметрыСтраницыКонтента(
		ЭтотОбъект.ЗначенияМаршрута.Получить("id"), 
		ИдентификаторСекции);

	Возврат Представление(ИмяСтраницыПредставления, ПараметрыСтраницы);
	
КонецФункции

ИдентификаторСекции = Неопределено;