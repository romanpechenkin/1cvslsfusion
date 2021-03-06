&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ПредложитьПерезаполнитьЦены();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПредложитьПерезаполнитьЦены();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	УстановитьВидимостьТабличнойЧастиРасчеты();
	
	ПредложитьПерезаполнитьЦены();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаВключаетНДСПриИзменении(Элемент)
	
	ПредложитьПересчитатьЦены();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураНоменклатураПриИзменении(Элемент)
	
	ПерезаполнитьЦену(Элементы.Номенклатура.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураКоличествоПриИзменении(Элемент)
	
	КлиентСервер.ПересчитатьСтрокуТабличнойЧастиПриИзмененииКоличества(Элементы.Номенклатура.ТекущиеДанные, Объект.ЦенаВключаетНДС);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураЦенаПриИзменении(Элемент)
	
	КлиентСервер.ПересчитатьСтрокуТабличнойЧастиПриИзмененииЦены(Элементы.Номенклатура.ТекущиеДанные, Объект.ЦенаВключаетНДС);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураСуммаПриИзменении(Элемент)
	
	КлиентСервер.ПересчитатьСтрокуТабличнойЧастиПриИзмененииСуммы(Элементы.Номенклатура.ТекущиеДанные, Объект.ЦенаВключаетНДС);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураСтавкаНДСПриИзменении(Элемент)
	
	КлиентСервер.ПересчитатьСтрокуТабличнойЧастиПриИзмененииСтавкиНДС(Элементы.Номенклатура.ТекущиеДанные, Объект.ЦенаВключаетНДС);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураНДСПриИзменении(Элемент)
	
	КлиентСервер.ПересчитатьСтрокуТабличнойЧастиПриИзмененииНДС(Элементы.Номенклатура.ТекущиеДанные, Объект.ЦенаВключаетНДС);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредложитьПерезаполнитьЦены()
	
	Если Объект.Номенклатура.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Договор) Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ПредложитьПерезаполнитьЦеныЗавершение", ЭтотОбъект), "Перезаполнить цены?", РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредложитьПерезаполнитьЦеныЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПерезаполнитьЦены();
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьЦены()
	
	МассивНоменклатуры = Новый Массив;
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.Номенклатура Цикл
		
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) Тогда
			МассивНоменклатуры.Добавить(СтрокаТабличнойЧасти.Номенклатура);
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЦеныПоставщиковСрезПоследних.Номенклатура КАК Номенклатура,
	|	ЦеныПоставщиковСрезПоследних.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныПоставщиков.СрезПоследних(
	|			&Период,
	|			Контрагент = &Контрагент
	|				И Договор = &Договор
	|				И Номенклатура В (&Номенклатура)
	|				И Регистратор <> &Регистратор) КАК ЦеныПоставщиковСрезПоследних";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Период", Сервер.ПолучитьГраницуИсключаяДокумент(Объект));
	Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
	Запрос.УстановитьПараметр("Договор", Объект.Договор);
	Запрос.УстановитьПараметр("Номенклатура", МассивНоменклатуры);
	Запрос.УстановитьПараметр("Регистратор", Объект.Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаЗапроса.Следующий() Цикл
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.Номенклатура.НайтиСтроки(Новый Структура("Номенклатура", ВыборкаЗапроса.Номенклатура)) Цикл
			
			Если Объект.ЦенаВключаетНДС Тогда
				СтавкаНДСЧислом = КлиентСервер.ПолучитьСтавкуНДСЧислом(СтрокаТабличнойЧасти.СтавкаНДС);
				СтрокаТабличнойЧасти.Цена = ВыборкаЗапроса.Цена * (100 + СтавкаНДСЧислом) / 100;
			Иначе
				СтрокаТабличнойЧасти.Цена = ВыборкаЗапроса.Цена;
			КонецЕсли;
			
			КлиентСервер.ПересчитатьСтрокуТабличнойЧастиПриИзмененииЦены(СтрокаТабличнойЧасти, Объект.ЦенаВключаетНДС);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьЦену(СтрокаТабличнойЧасти)
	
	Цена = ПолучитьЦену(Элементы.Номенклатура.ТекущиеДанные.Номенклатура);
	
	Если Цена <> Неопределено Тогда
		
		Если Объект.ЦенаВключаетНДС Тогда
			СтавкаНДСЧислом = КлиентСервер.ПолучитьСтавкуНДСЧислом(Элементы.Номенклатура.ТекущиеДанные.СтавкаНДС);
			Элементы.Номенклатура.ТекущиеДанные.Цена = Цена * (100 + СтавкаНДСЧислом) / 100;
		Иначе
			Элементы.Номенклатура.ТекущиеДанные.Цена = Цена;
		КонецЕсли;
		
		КлиентСервер.ПересчитатьСтрокуТабличнойЧастиПриИзмененииЦены(Элементы.Номенклатура.ТекущиеДанные, Объект.ЦенаВключаетНДС);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЦену(Номенклатура)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЦеныПоставщиковСрезПоследних.Номенклатура КАК Номенклатура,
	|	ЦеныПоставщиковСрезПоследних.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныПоставщиков.СрезПоследних(
	|			&Период,
	|			Контрагент = &Контрагент
	|				И Договор = &Договор
	|				И Номенклатура = &Номенклатура
	|				И Регистратор <> &Регистратор) КАК ЦеныПоставщиковСрезПоследних";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Период", Сервер.ПолучитьГраницуИсключаяДокумент(Объект));
	Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
	Запрос.УстановитьПараметр("Договор", Объект.Договор);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Регистратор", Объект.Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		
		ВыборкаЗапроса = РезультатЗапроса.Выбрать();
		ВыборкаЗапроса.Следующий();
		
		Возврат ВыборкаЗапроса.Цена;
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПредложитьПересчитатьЦены()
	
	Если Объект.Номенклатура.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ПредложитьПересчитатьЦеныЗавершение", ЭтотОбъект), "Пересчитать цены?", РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредложитьПересчитатьЦеныЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПересчитатьЦены();
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьЦены()
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.Номенклатура Цикл
		КлиентСервер.ПересчитатьСтрокуТабличнойЧастиПриИзмененииЦенаВключаетНДС(СтрокаТабличнойЧасти, Объект.ЦенаВключаетНДС);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьВидимостьТабличнойЧастиРасчеты();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьТабличнойЧастиРасчеты()
	
	Если Объект.Договор.ДетализацияРасчетов = Перечисления.ТипыДетализацииРасчетов.ПоРасчетнымДокументам Тогда
		Элементы.Расчеты.Видимость = Истина;
	Иначе
		Элементы.Расчеты.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРасчеты(Команда)
	
	ЗаполнитьРасчетыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРасчетыНаСервере()
	
	Объект.Расчеты.Очистить();
	
	ОставшаясяСумма = Объект.Номенклатура.Итог("СуммаСНДС");
	
	Если ОставшаясяСумма <= 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	РасчетыСКонтрагентамиОстатки.РасчетныйДокумент КАК РасчетныйДокумент,
	|	-РасчетыСКонтрагентамиОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.РасчетыСКонтрагентами.Остатки(
	|			&Период,
	|			Контрагент = &Контрагент
	|				И Договор = &Договор) КАК РасчетыСКонтрагентамиОстатки
	|ГДЕ
	|	РасчетыСКонтрагентамиОстатки.СуммаОстаток < 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	РасчетыСКонтрагентамиОстатки.РасчетныйДокумент.Дата,
	|	РасчетыСКонтрагентамиОстатки.РасчетныйДокумент.Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Период", Сервер.ПолучитьГраницуИсключаяДокумент(Объект));
	Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
	Запрос.УстановитьПараметр("Договор", Объект.Договор);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаЗапроса.Следующий() Цикл
		
		СтрокаТабличнойЧасти = Объект.Расчеты.Добавить();
		СтрокаТабличнойЧасти.РасчетныйДокумент = ВыборкаЗапроса.РасчетныйДокумент;
		
		Если ВыборкаЗапроса.Сумма > ОставшаясяСумма Тогда
			
			СтрокаТабличнойЧасти.Сумма = ВыборкаЗапроса.Сумма;
			
			ОставшаясяСумма = ОставшаясяСумма - ВыборкаЗапроса.Сумма;
			
		Иначе
			
			СтрокаТабличнойЧасти.Сумма = ОставшаясяСумма;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьДополнительныеРасходыПоКоличеству(Команда)
	
	Ответ = РаспределитьДополнительныеРасходы("Количество");
	
	Если Ответ <> Неопределено Тогда
		ПоказатьПредупреждение(, Ответ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьДополнительныеРасходыПоСумме(Команда)
	
	Ответ = РаспределитьДополнительныеРасходы("СуммаСНДС");
	
	Если Ответ <> Неопределено Тогда
		ПоказатьПредупреждение(, Ответ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РаспределитьДополнительныеРасходы(ИмяБазы)
	
	База = 0;
	СуммаДополнительныхРасходов = 0;
	ОсталосьРаспределить = 0;
	
	Для А = 0 По Объект.Номенклатура.Количество() - 1 Цикл
		
		Если Объект.Номенклатура[А].Номенклатура.Услуга Тогда
			СуммаДополнительныхРасходов = СуммаДополнительныхРасходов + Объект.Номенклатура[А].Сумма;
			ОсталосьРаспределить = ОсталосьРаспределить + Объект.Номенклатура[А].Сумма;
		Иначе
			База = База + Объект.Номенклатура[А][ИмяБазы];
		КонецЕсли;
		
	КонецЦикла;
	
	Если База = 0 Тогда
		Возврат "Нет базы для распределения";
	КонецЕсли;
	
	Объект.ДополнительныеРасходы.Очистить();
	
	Для А = 0 По Объект.Номенклатура.Количество() - 1 Цикл
		
		Если Объект.Номенклатура[А].Номенклатура.Услуга Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТабличнойЧасти = Объект.ДополнительныеРасходы.Добавить();
		СтрокаТабличнойЧасти.Номенклатура = Объект.Номенклатура[А].Номенклатура;
		СтрокаТабличнойЧасти.Сумма = СуммаДополнительныхРасходов / База * Объект.Номенклатура[А][ИмяБазы];
		
		ОсталосьРаспределить = ОсталосьРаспределить - СтрокаТабличнойЧасти.Сумма;
		
	КонецЦикла;
	
	Если ОсталосьРаспределить <> 0 Тогда
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Сумма + ОсталосьРаспределить;
	КонецЕсли;
	
КонецФункции
