// #Использовать "../modules"

Перем ДеревоКонтента Экспорт;

Процедура ПриСозданииОбъекта(Знач КаталогКонтента)
	
	Заполнить(КаталогКонтента);
	
КонецПроцедуры

Процедура Заполнить(Знач КаталогКонтента) 
	ПрочитатьКаталог(КаталогКонтента, ДеревоКонтента.Строки);
КонецПроцедуры

Процедура ПрочитатьКаталог(Каталог, КоллекцияСтрок)

	ФайлЗаголовковИмя = "titles.json";
	ФайлЗаголовка = Новый Файл(ОбъединитьПути(Каталог, ФайлЗаголовковИмя));
	Если ФайлЗаголовка.Существует() Тогда
		КартаИмен = ПрочитатьКартуИмен(ФайлЗаголовка.ПолноеИмя);
	Иначе
		КартаИмен = КартаИмен();
	КонецЕсли;

	КартаИмен.Колонки.Добавить("Файл");
	ВсеФайлы = НайтиФайлы(Каталог, ПолучитьМаскуВсеФайлы());
	Для Каждого Файл Из ВсеФайлы Цикл

		Если Файл.ЭтоКаталог() Тогда
			Искомое = Файл.Имя;
		Иначе
			Искомое = Файл.ИмяБезРасширения;
			Если Файл.Имя = ФайлЗаголовковИмя Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Описание = КартаИмен.Найти(Искомое, "Имя");
		Если Описание = Неопределено Тогда
			Описание = КартаИмен.Добавить();
			Описание.Имя = Искомое;
			Описание.Представление = Искомое;
		КонецЕсли;

		Описание.Файл = Файл;
	КонецЦикла;

	Для Каждого Описание Из КартаИмен Цикл
		Строка = КоллекцияСтрок.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, Описание, "Имя,Представление");

		Строка.Путь = Описание.Файл.ПолноеИмя;
		Если Строка.Родитель = Неопределено Тогда
			Строка.Тип = "Раздел";
		Иначе
			Строка.Тип = ?(Описание.Файл.ЭтоКаталог(), "Подраздел", "Статья");
		КонецЕсли;

		Если Строка.Тип <> "Статья" Тогда
			ПрочитатьКаталог(Описание.Файл.ПолноеИмя, Строка.Строки);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Функция КартаИмен()
	Карта = Новый ТаблицаЗначений;
	Карта.Колонки.Добавить("Имя");
	Карта.Колонки.Добавить("Представление");

	Возврат Карта;

КонецФункции

Функция ПрочитатьКартуИмен(Знач Путь)
	
	Чтение = Новый ЧтениеJSON();
	Чтение.ОткрытьФайл(Путь, КодировкаТекста.UTF8);
	
	Карта = КартаИмен();

	Если Чтение.Прочитать() Тогда

		Пока Чтение.Прочитать() Цикл
			Если Не Чтение.ТипТекущегоЗначения = ТипЗначенияJSON.ИмяСвойства Тогда
				Прервать; // неверная структура
			КонецЕсли;

			Запись = Карта.Добавить();
			Запись.Имя = Чтение.ТекущееЗначение;
			Чтение.Прочитать();
			Запись.Представление = Чтение.ТекущееЗначение;

		КонецЦикла;

	КонецЕсли;

	Чтение.Закрыть();
	Возврат Карта;

КонецФункции

ДеревоКонтента = Новый ДеревоЗначений();
ДеревоКонтента.Колонки.Добавить("Имя");
ДеревоКонтента.Колонки.Добавить("Путь");
ДеревоКонтента.Колонки.Добавить("Представление");
ДеревоКонтента.Колонки.Добавить("Тип");