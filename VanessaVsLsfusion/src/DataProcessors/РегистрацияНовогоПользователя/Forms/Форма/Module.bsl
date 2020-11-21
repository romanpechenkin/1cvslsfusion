&НаКлиенте
Процедура Зарегистрировать(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Объект.ОтображатьПароль
		И Объект.Пароль <> Объект.Подтверждение Тогда
		ПоказатьПредупреждение(, "Пароль не совпадает с подтверждением");
		Возврат;
	КонецЕсли;
	
	Если ЗарегистрироватьНовогоПользователя() Тогда
		ЗавершитьРаботуСистемы(Ложь, Истина, "/N""" + Объект.Имя + """ /P""" + Объект.Пароль + """");
	Иначе
		ПоказатьПредупреждение(, "Пользователь с таким именем уже зарегистрирован");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗарегистрироватьНовогоПользователя()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПользователиИнформационнойБазы.НайтиПоИмени(Объект.Имя) = Неопределено Тогда
		
		НовыйПользователь = ПользователиИнформационнойБазы.СоздатьПользователя();
		НовыйПользователь.Имя = Объект.Имя;
		НовыйПользователь.ПолноеИмя = Объект.Имя;
		НовыйПользователь.Пароль = Объект.Пароль;
		НовыйПользователь.АутентификацияСтандартная = Истина;
		НовыйПользователь.ПоказыватьВСпискеВыбора = Ложь;
		НовыйПользователь.Роли.Добавить(Метаданные.Роли.Пользователь);
		НовыйПользователь.Записать();
		
		УстановитьПривилегированныйРежим(Ложь);
		
		Возврат Истина;
		
	Иначе
		
		УстановитьПривилегированныйРежим(Ложь);
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ЗавершитьРаботуСистемы(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьПарольПриИзменении(Элемент)
	
	Элементы.Пароль.РежимПароля = Не Объект.ОтображатьПароль;
	Элементы.Подтверждение.Видимость = Не Объект.ОтображатьПароль;
	
КонецПроцедуры
