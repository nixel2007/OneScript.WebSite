Перем мТокенВерсии;
Перем мВарианты;
Перем мНесуществующаяВерсия;

Процедура ПриСозданииОбъекта(Знач Токен)
	мТокенВерсии = Токен;
	мНесуществующаяВерсия = Ложь;
КонецПроцедуры

Функция ТокенВерсии() Экспорт
	Возврат мТокенВерсии;
КонецФункции

// Получает таблицу вариантов дистрибутива
// Возвращаемое значение:
//  Наименование - Строка
//  Варианты - ТаблицаЗначений
//    - Идентификатор: Строка
//    - Представление: Строка
//    - Ссылка - относительный путь файла дистрибутива
//    - ДатаФайла - дата создания файла
//
Функция ПолучитьСостав() Экспорт
	Если мВарианты = Неопределено Тогда
		ЗаполнитьДистрибутивы();
	КонецЕсли;

	Возврат мВарианты;
КонецФункции

Функция Существует() Экспорт
	ПолучитьСостав();
	Возврат мНесуществующаяВерсия = Ложь;
КонецФункции

Функция НайтиВариантСборки(Идентификатор, Разрядность) Экспорт
	Найденное = мВарианты.НайтиСтроки(Новый Структура("Идентификатор, Архитектура", Идентификатор, Разрядность));
	Если Найденное.Количество() Тогда
		Возврат Найденное[0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Процедура ЗаполнитьДистрибутивы()
	
	КорневойКаталог = УправлениеКонтентом.ПолучитьКаталогСборок();
	КаталогВерсии = ОбъединитьПути(КорневойКаталог, мТокенВерсии);
	Каталог = Новый Файл(КаталогВерсии);
	
	Если Не Каталог.Существует() или Не Каталог.ЭтоКаталог() или Не СтрНачинаетсяС(Каталог.ПолноеИмя, КорневойКаталог) Тогда

		мНесуществующаяВерсия = Истина;
		мВарианты = ТаблицаФайлов();
		Возврат;

	КонецЕсли;

	Манифест = ПолучитьМанифест();
	мВарианты = ТаблицаФайлов();

	// по манифесту найти целевые файлы
	Для Каждого ВариантСборки Из Манифест.ПолучитьДистрибутивы() Цикл
		
		НайденныеФайлы = ВариантСборки.ПолучитьФайлы(Каталог.ПолноеИмя);
		Если Не НайденныеФайлы.Количество() Тогда
			Продолжить;
		КонецЕсли;

		Для Каждого НайденныйФайл Из НайденныеФайлы Цикл
			
			Файл = НайденныйФайл.Файл;
			
			СтрокаДистрибутива = мВарианты.Добавить();
			СтрокаДистрибутива.Идентификатор = ВариантСборки.ПолучитьИдентификатор();
			СтрокаДистрибутива.Архитектура = НайденныйФайл.Архитектура;
			СтрокаДистрибутива.ВидДистрибутива = НайденныйФайл.ВидДистрибутива;
			СтрокаДистрибутива.ИмяФайла = Файл.Имя;
			СтрокаДистрибутива.ДатаФайла = Формат(Файл.ПолучитьВремяИзменения(), "ДЛФ=Д");
			СтрокаДистрибутива.Ссылка = "/downloads/" + ОбъединитьПути(мТокенВерсии, НайденныйФайл.Подкаталог, Файл.Имя);
			#Если Windows Тогда
				СтрокаДистрибутива.Ссылка = СтрЗаменить(СтрокаДистрибутива.Ссылка, "\", "/");
			#КонецЕсли
			СтрокаДистрибутива.Файл = НайденныйФайл.Файл;
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

Функция ТаблицаФайлов()
	Варианты = Новый ТаблицаЗначений();
	Варианты.Колонки.Добавить("ИмяФайла");
	Варианты.Колонки.Добавить("Идентификатор");
	Варианты.Колонки.Добавить("Архитектура");
	Варианты.Колонки.Добавить("ВидДистрибутива");
	Варианты.Колонки.Добавить("ДатаФайла");
	Варианты.Колонки.Добавить("Ссылка");
	Варианты.Колонки.Добавить("Файл");

	Возврат Варианты;
КонецФункции

Функция ПолучитьМанифест()
	
	МанифестПоискаФайлов = Новый МанифестПоискаФайлов();
	МанифестПоискаФайлов.СоздатьДистрибутив("exe", "Windows Installer (exe)")
		.ДобавитьФайл(Архитектуры.Арх86, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх86), "*.exe")
		.ДобавитьФайл(Архитектуры.Арх64, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх64), "*.exe");

	МанифестПоискаФайлов.СоздатьДистрибутив("zip", "Zip-архив")
		.ДобавитьФайл(Архитектуры.Арх86, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх86), "*.zip")
		.ДобавитьФайл(Архитектуры.Арх64, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх64), "*.zip");

	МанифестПоискаФайлов.СоздатьДистрибутив("rpm", "Fedora/CentOS (rpm)")
		.ДобавитьФайл(Архитектуры.Арх64, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх64), "*.rpm");

	МанифестПоискаФайлов.СоздатьДистрибутив("deb", "Debian/Ubuntu (deb)")
		.ДобавитьФайл(Архитектуры.Арх64, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх64), "*.deb");
	
	МанифестПоискаФайлов.СоздатьДистрибутив("vsix", "Расширение VSCode")
		.ДобавитьФайл(Архитектуры.Арх64, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх64), "*.vsix")
		.ДобавитьФайл(Архитектуры.Арх86, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх86), "*.vsix");
	
	МанифестПоискаФайлов.СоздатьДистрибутив("fdd", "Требующий установки .NET (FDD)")
		.ДобавитьФайл(Архитектуры.Арх86, "", "*-fdd-x86.zip")
		.ДобавитьФайл(Архитектуры.Арх64, "", "*-fdd-x64.zip");

	МанифестПоискаФайлов.СоздатьДистрибутив("scd-win", "Независимый дистрибутив (Windows)")
		.ДобавитьФайл(Архитектуры.Арх86, "", "*-win-x86.zip")
		.ДобавитьФайл(Архитектуры.Арх64, "", "*-win-x64.zip");

	МанифестПоискаФайлов.СоздатьДистрибутив("scd-lin", "Независимый дистрибутив (Linux)")
		.ДобавитьФайл(Архитектуры.Арх86, "", "*-linux-x64.zip")
		.ДобавитьФайл(Архитектуры.Арх64, "", "*-linux-x64.zip");

	Возврат МанифестПоискаФайлов;
КонецФункции