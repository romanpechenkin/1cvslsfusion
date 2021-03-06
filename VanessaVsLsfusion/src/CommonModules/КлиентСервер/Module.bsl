Функция ПолучитьСтавкуНДСЧислом(СтавкаНДС) Экспорт
	
	Если СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.ДесятьПроцентов") Тогда
		Возврат 10;
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.ВосемнадцатьПроцентов") Тогда
		Возврат 18;
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.ДвадцатьПроцентов") Тогда
		Возврат 20;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Процедура ПересчитатьСтрокуТабличнойЧастиПриИзмененииКоличества(СтрокаТабличнойЧасти, ЦенаВключаетНДС) Экспорт
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена) Тогда
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.Количество;
	ИначеЕсли ЗначениеЗаполнено(СтрокаТабличнойЧасти.Сумма)
		И ЗначениеЗаполнено(СтрокаТабличнойЧасти.Количество) Тогда
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество;
	КонецЕсли;
	
	ПересчитатьСтрокуТабличнойЧастиПриИзмененииСтавкиНДС(СтрокаТабличнойЧасти, ЦенаВключаетНДС);
	
КонецПроцедуры

Процедура ПересчитатьСтрокуТабличнойЧастиПриИзмененииЦены(СтрокаТабличнойЧасти, ЦенаВключаетНДС) Экспорт
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Количество) Тогда
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.Количество;
	ИначеЕсли ЗначениеЗаполнено(СтрокаТабличнойЧасти.Сумма)
		И ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена) Тогда
		СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Цена;
	КонецЕсли;
	
	ПересчитатьСтрокуТабличнойЧастиПриИзмененииСтавкиНДС(СтрокаТабличнойЧасти, ЦенаВключаетНДС);
	
КонецПроцедуры

Процедура ПересчитатьСтрокуТабличнойЧастиПриИзмененииСуммы(СтрокаТабличнойЧасти, ЦенаВключаетНДС) Экспорт
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Количество) Тогда
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество;
	ИначеЕсли ЗначениеЗаполнено(СтрокаТабличнойЧасти.Сумма)
		И ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена) Тогда
		СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Цена;
	КонецЕсли;
	
	ПересчитатьСтрокуТабличнойЧастиПриИзмененииСтавкиНДС(СтрокаТабличнойЧасти, ЦенаВключаетНДС);
	
КонецПроцедуры

Процедура ПересчитатьСтрокуТабличнойЧастиПриИзмененииСтавкиНДС(СтрокаТабличнойЧасти, ЦенаВключаетНДС) Экспорт
	
	СтавкаНДСЧислом = ПолучитьСтавкуНДСЧислом(СтрокаТабличнойЧасти.СтавкаНДС);
	
	Если ЦенаВключаетНДС Тогда
		СтрокаТабличнойЧасти.НДС = СтрокаТабличнойЧасти.Сумма * СтавкаНДСЧислом / (100 + СтавкаНДСЧислом);
	Иначе
		СтрокаТабличнойЧасти.НДС = СтрокаТабличнойЧасти.Сумма * СтавкаНДСЧислом / 100;
	КонецЕсли;
	
	ПересчитатьСтрокуТабличнойЧастиПриИзмененииНДС(СтрокаТабличнойЧасти, ЦенаВключаетНДС);
	
КонецПроцедуры

Процедура ПересчитатьСтрокуТабличнойЧастиПриИзмененииНДС(СтрокаТабличнойЧасти, ЦенаВключаетНДС) Экспорт
	
	Если ЦенаВключаетНДС Тогда
		СтрокаТабличнойЧасти.СуммаСНДС = СтрокаТабличнойЧасти.Сумма;
	Иначе
		СтрокаТабличнойЧасти.СуммаСНДС = СтрокаТабличнойЧасти.Сумма + СтрокаТабличнойЧасти.НДС;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПересчитатьСтрокуТабличнойЧастиПриИзмененииЦенаВключаетНДС(СтрокаТабличнойЧасти, ЦенаВключаетНДС) Экспорт
	
	СтавкаНДСЧислом = ПолучитьСтавкуНДСЧислом(СтрокаТабличнойЧасти.СтавкаНДС);
	
	Если ЦенаВключаетНДС Тогда
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Цена * (100 + СтавкаНДСЧислом) / 100;
	Иначе
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Цена * 100 / (100 + СтавкаНДСЧислом);
	КонецЕсли;
	
	ПересчитатьСтрокуТабличнойЧастиПриИзмененииЦены(СтрокаТабличнойЧасти, ЦенаВключаетНДС);
	
КонецПроцедуры

Процедура ПересчитатьШапкуДокументаПриИзмененииСуммаВключаетНДС(ДокументОбъект) Экспорт
	
	СтавкаНДСЧислом = ПолучитьСтавкуНДСЧислом(ДокументОбъект.СтавкаНДС);
	
	Если ДокументОбъект.СуммаВключаетНДС Тогда
		ДокументОбъект.Сумма = ДокументОбъект.Сумма * (100 + СтавкаНДСЧислом) / 100;
	Иначе
		ДокументОбъект.Сумма = ДокументОбъект.Сумма * 100 / (100 + СтавкаНДСЧислом);
	КонецЕсли;
	
	ПересчитатьШапкуДокументаПриИзмененииСуммы(ДокументОбъект);
	
КонецПроцедуры

Процедура ПересчитатьШапкуДокументаПриИзмененииСуммы(ДокументОбъект) Экспорт
	
	ПересчитатьШапкуДокументаПриИзмененииСтавкиНДС(ДокументОбъект);
	
КонецПроцедуры

Процедура ПересчитатьШапкуДокументаПриИзмененииСтавкиНДС(ДокументОбъект) Экспорт
	
	СтавкаНДСЧислом = ПолучитьСтавкуНДСЧислом(ДокументОбъект.СтавкаНДС);
	
	Если ДокументОбъект.СуммаВключаетНДС Тогда
		ДокументОбъект.НДС = ДокументОбъект.Сумма * СтавкаНДСЧислом / (100 + СтавкаНДСЧислом);
	Иначе
		ДокументОбъект.НДС = ДокументОбъект.Сумма * СтавкаНДСЧислом / 100;
	КонецЕсли;
	
	ПересчитатьШапкуДокументаПриИзмененииНДС(ДокументОбъект);
	
КонецПроцедуры

Процедура ПересчитатьШапкуДокументаПриИзмененииНДС(ДокументОбъект) Экспорт
	
	Если ДокументОбъект.СуммаВключаетНДС Тогда
		ДокументОбъект.СуммаСНДС = ДокументОбъект.Сумма;
	Иначе
		ДокументОбъект.СуммаСНДС = ДокументОбъект.Сумма + ДокументОбъект.НДС;
	КонецЕсли;
	
КонецПроцедуры
