
Перем Арх86 Экспорт;
Перем Арх64 Экспорт;
Перем Универсальная Экспорт;

Перем Представления;

Функция ПодкаталогАрхитектуры(Знач Архитектура) Экспорт
	Возврат Представления[Архитектура].Подкаталог;
КонецФункции

Функция ПредставлениеАрхитектуры()
	Возврат Новый Структура("Подкаталог");
КонецФункции

Процедура ДобавитьПредставления(Архитектура, Подкаталог)
	Представление = ПредставлениеАрхитектуры();
	Представление.Подкаталог = Подкаталог;
	Представления[Архитектура] = Представление;
КонецПроцедуры

////////////////////////////////////////////////////////

Арх86 = "x86";
Универсальная = "x64";

Представления = Новый Соответствие();
ДобавитьПредставления(Арх86, "");
ДобавитьПредставления(Универсальная, "x64");