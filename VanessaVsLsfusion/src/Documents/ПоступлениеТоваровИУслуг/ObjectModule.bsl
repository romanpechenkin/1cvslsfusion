Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Сумма = Номенклатура.Итог("Сумма");
	НДС = Номенклатура.Итог("НДС");
	СуммаСНДС = Номенклатура.Итог("СуммаСНДС");
	
	Если Договор.ДетализацияРасчетов = Перечисления.ТипыДетализацииРасчетов.ПоРасчетнымДокументам Тогда
		
		Если РежимЗаписи = РежимЗаписиДокумента.Проведение
			И Расчеты.Итог("Сумма") > СуммаСНДС Тогда
			Сообщить("Ошибка при проведении " + Ссылка + ", сумма расчетов больше суммы документа");
			Отказ = Истина;
		КонецЕсли;
		
	Иначе
		Расчеты.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Автор = ПараметрыСеанса.ТекущийПользователь;
	Склад = Константы.СкладПоУмолчанию.Получить();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.ТоварыНаСкладах.Записывать = Истина;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВложенныйЗапрос.Склад КАК Склад,
	|	МИНИМУМ(ВложенныйЗапрос.НомерСтроки) КАК НомерСтроки,
	|	СУММА(ВложенныйЗапрос.Количество) КАК Количество,
	|	СУММА(ВложенныйЗапрос.Сумма) КАК Сумма,
	|	СУММА(ЕСТЬNULL(ВложенныйЗапрос.КоличествоОстаток, 0)) КАК КоличествоОстаток
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|		ТоварыНаСкладахОстатки.Склад КАК Склад,
	|		NULL КАК НомерСтроки,
	|		NULL КАК Количество,
	|		NULL КАК Сумма,
	|		ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоОстаток
	|	ИЗ
	|		РегистрНакопления.ТоварыНаСкладах.Остатки(, Партия = &Ссылка) КАК ТоварыНаСкладахОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыНаСкладахОбороты.Номенклатура,
	|		ТоварыНаСкладахОбороты.Склад,
	|		NULL,
	|		NULL,
	|		NULL,
	|		-ТоварыНаСкладахОбороты.КоличествоОборот
	|	ИЗ
	|		РегистрНакопления.ТоварыНаСкладах.Обороты(, , Регистратор, ) КАК ТоварыНаСкладахОбороты
	|	ГДЕ
	|		ТоварыНаСкладахОбороты.Регистратор = &Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПоступлениеТоваровИУслугНоменклатура.Номенклатура,
	|		&Склад,
	|		ПоступлениеТоваровИУслугНоменклатура.НомерСтроки,
	|		ПоступлениеТоваровИУслугНоменклатура.Количество,
	|		ПоступлениеТоваровИУслугНоменклатура.СуммаСНДС,
	|		ПоступлениеТоваровИУслугНоменклатура.Количество
	|	ИЗ
	|		Документ.ПоступлениеТоваровИУслуг.Номенклатура КАК ПоступлениеТоваровИУслугНоменклатура
	|	ГДЕ
	|		ПоступлениеТоваровИУслугНоменклатура.Ссылка = &Ссылка
	|		И НЕ ПоступлениеТоваровИУслугНоменклатура.Номенклатура.Услуга) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Склад
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Склад", Склад);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаИзЗапроса = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаИзЗапроса.Следующий() Цикл
		
		Если ВыборкаИзЗапроса.КоличествоОстаток < 0 Тогда
			
			Сообщить("Ошибка при проведении " + Ссылка + ", отрицательный остаток товаров на складе:");
			Сообщить("	Товар " + ВыборкаИзЗапроса.Номенклатура + " на складе " + ВыборкаИзЗапроса.Склад + ": " + ВыборкаИзЗапроса.КоличествоОстаток);
			
			Пока ВыборкаИзЗапроса.Следующий() Цикл
				
				Если ВыборкаИзЗапроса.КоличествоОстаток < 0 Тогда
					Сообщить("	Товар " + ВыборкаИзЗапроса.Номенклатура + " на складе " + ВыборкаИзЗапроса.Склад + ": " + ВыборкаИзЗапроса.КоличествоОстаток);
				КонецЕсли;
				
			КонецЦикла;
			
			Отказ = Истина;
			
			Возврат;
			
		ИначеЕсли ВыборкаИзЗапроса.Количество <> NULL Тогда
			Движение = Движения.ТоварыНаСкладах.ДобавитьПриход();
			Движение.Период = Дата;
			Движение.Склад = Склад;
			Движение.Номенклатура = ВыборкаИзЗапроса.Номенклатура;
			Движение.Партия = Ссылка;
			Движение.Количество = ВыборкаИзЗапроса.Количество;
			Движение.Сумма = ВыборкаИзЗапроса.Сумма;
		КонецЕсли;
		
	КонецЦикла;
	
	Для А = 0 По ДополнительныеРасходы.Количество() - 1 Цикл
		
		Движение = Движения.ТоварыНаСкладах.ДобавитьПриход();
		Движение.Период = Дата;
		Движение.Склад = Склад;
		Движение.Номенклатура = ДополнительныеРасходы[А].Номенклатура;
		
		Если ЗначениеЗаполнено(ДополнительныеРасходы[А].Партия) Тогда
			Движение.Партия = ДополнительныеРасходы[А].Партия;
		Иначе
			Движение.Партия = Ссылка;
		КонецЕсли;
		
		Движение.Сумма = ДополнительныеРасходы[А].Сумма;
		
	КонецЦикла;
	
	Движения.ЦеныПоставщиков.Записывать = Истина;
	
	ТЗНоменклатура = Номенклатура.ВыгрузитьКолонки("Номенклатура, Количество, СуммаСНДС, НДС");
	ТЗНоменклатура.Свернуть("Номенклатура", "Количество, СуммаСНДС, НДС");
	
	Для А = 0 По ТЗНоменклатура.Количество() - 1 Цикл
		
		Движение = Движения.ЦеныПоставщиков.Добавить();
		Движение.Период = Дата;
		Движение.Контрагент = Контрагент;
		Движение.Договор = Договор;
		Движение.Номенклатура = ТЗНоменклатура[А].Номенклатура;
		
		Если Номенклатура[А].Количество = 0 Тогда
			Движение.Цена = 0;
		Иначе
			Движение.Цена = (ТЗНоменклатура[А].СуммаСНДС - ТЗНоменклатура[А].НДС) / ТЗНоменклатура[А].Количество;
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.РасчетыСКонтрагентами.Записывать = Истина;
	
	Если Договор.ДетализацияРасчетов = Перечисления.ТипыДетализацииРасчетов.ПоРасчетнымДокументам Тогда
		
		ОставшаясяСумма = СуммаСНДС;
		
		Для А = 0 По Расчеты.Количество() - 1 Цикл
			
			Движение = Движения.РасчетыСКонтрагентами.ДобавитьПриход();
			Движение.Период = Дата;
			Движение.Контрагент = Контрагент;
			Движение.Договор = Договор;
			Движение.РасчетныйДокумент = Расчеты[А].РасчетныйДокумент;
			Движение.Сумма = Расчеты[А].Сумма;
			
			ОставшаясяСумма = ОставшаясяСумма - Расчеты[А].Сумма;
			
		КонецЦикла;
		
		Если ОставшаясяСумма <> 0 Тогда
			Движение = Движения.РасчетыСКонтрагентами.ДобавитьПриход();
			Движение.Период = Дата;
			Движение.Контрагент = Контрагент;
			Движение.Договор = Договор;
			Движение.РасчетныйДокумент = Ссылка;
			Движение.Сумма = ОставшаясяСумма;
		КонецЕсли;
		
	Иначе
		Движение = Движения.РасчетыСКонтрагентами.ДобавитьПриход();
		Движение.Период = Дата;
		Движение.Контрагент = Контрагент;
		Движение.Договор = Договор;
		Движение.Сумма = СуммаСНДС;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВложенныйЗапрос.Склад КАК Склад,
	|	СУММА(ВложенныйЗапрос.КоличествоОстаток) КАК КоличествоОстаток
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|		ТоварыНаСкладахОстатки.Склад КАК Склад,
	|		ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоОстаток
	|	ИЗ
	|		РегистрНакопления.ТоварыНаСкладах.Остатки(, Партия = &Ссылка) КАК ТоварыНаСкладахОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыНаСкладахОбороты.Номенклатура,
	|		ТоварыНаСкладахОбороты.Склад,
	|		-ТоварыНаСкладахОбороты.КоличествоОборот
	|	ИЗ
	|		РегистрНакопления.ТоварыНаСкладах.Обороты(, , Регистратор, Партия = &Ссылка) КАК ТоварыНаСкладахОбороты
	|	ГДЕ
	|		ТоварыНаСкладахОбороты.Регистратор = &Ссылка) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Склад
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВложенныйЗапрос.КоличествоОстаток) < 0";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Сообщить("Ошибка при отмене проведения " + Ссылка + ", отрицательный остаток товаров:");
		
		ВыборкаИзЗапроса = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаИзЗапроса.Следующий() Цикл
			Сообщить("	Товар " + ВыборкаИзЗапроса.Номенклатура + " на складе " + ВыборкаИзЗапроса.Склад + ": " + ВыборкаИзЗапроса.КоличествоОстаток);
		КонецЦикла;
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Автор = ПараметрыСеанса.ТекущийПользователь;
	
КонецПроцедуры
