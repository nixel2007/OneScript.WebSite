#Использовать markdown
#Использовать fs

Функция ПолучитьСодержимоеMDФайла(ПутьКФайлу, Знач Кодировка = Неопределено) Экспорт

	Если Кодировка = Неопределено Тогда
		Кодировка = КодировкаТекста.UTF8;
	КонецЕсли;

	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ПутьКФайлу, Кодировка);
	Значение = ТекстовыйДокумент.ПолучитьТекст();
	ТекстовыйДокумент = Неопределено;
	Возврат Значение;

КонецФункции

Функция ПреобразоватьMDВHTML(Значение) Экспорт

	Парсер = Новый ПарсерРазметкиMD();
	Парсер.ВключитьРасширения = Истина;
	Возврат Парсер.СоздатьHTML(Значение);

КонецФункции

Функция ОбернутьВКавычки(Знач Строка);
	Если Лев(Строка, 1) = """" и Прав(Строка, 1) = """" Тогда
		Возврат Строка;
	Иначе
		Возврат """" + Строка + """";
	КонецЕсли;
КонецФункции

// пока в архиве

// Функция ОбновитьКонтентИзВнешнихИсточников() Экспорт

// 	БазовыйКаталог = ОбъединитьПути(СтартовыйСценарий().Каталог, "content");
// 	ИмяКаталогаКонтента = "oscriptiocontent";
// 	URLКонтента = "https://github.com/EvilBeaver/oscriptiocontent";
	
// 	ВременныйКаталог = ОбъединитьПути(КаталогВременныхФайлов(), "tmp-content");
// 	ФС.ОбеспечитьКаталог(ВременныйКаталог);
// 	ФС.ОбеспечитьПустойКаталог(ВременныйКаталог);

// 	КаталогКонтента = ОбъединитьПути(ВременныйКаталог, ИмяКаталогаКонтента);
// 	СтрокаКоманды = "git clone " + URLКонтента + " " + ОбернутьВКавычки(ОбъединитьПути(КаталогКонтента, "")); 
// 	ЗапуститьПриложение(СтрокаКоманды);

// 	ФС.КопироватьСодержимоеКаталога(КаталогКонтента, БазовыйКаталог);

// КонецФункции