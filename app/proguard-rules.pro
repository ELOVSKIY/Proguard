#<module-dir>/proguard-rules.pro - генерируется при создании модуля и может содержать кастомные правила
# Для библиотек AAR:  <library-dir>/proguard.txt
#               JAR: <library-dir>/META-INF/proguard/
# Правила бибилотек компиляции применяются во время компиляции
# Стоит помнить что правила из библиотек могут повлиять на компиляцию проекта,
# например отключение оптимизации кода

# <module-dir>/build/intermediates/proguard-rules/debug/aapt_rules.txt - AAPT2 генерируется
# после сборки с minifyEnabled true

# При оптимизации R8 применяет правила из всех источников
#
# Code Shrinking (Tree Shaking) - удаление ненужного кода, оно использует входные точки из файлов конфигурации
# и удаляет недостижимый код
# -keep - помечает класс как entry point
# это необбходимо в основном при использовании рефлексии или JNI так как может быть удален нужный код
# альтернатива - аннотация @Keep
#
#
-keep public class com.helicoptera.proguard.person.KeepPerson
-keep public class * extends android.app.Activity
-keepclassmembers public class com.helicoptera.proguard.person.KeepPrivatePerson

# найдет все классы наследуемые от view и сохраняет три конструктора и
# ВСЕ public void методы с любыми аргументыми начинающиеся на set
-keep public class * extends android.view.View {
      public <init>(android.content.Context);
      public <init>(android.content.Context, android.util.AttributeSet);
      public <init>(android.content.Context, android.util.AttributeSet, int);
      public void set*(...);
}
#сохранить все классы и их содержимое из пакета
-keep class com.helicoptera.** {*;}

#модификаторы keep
# includedescriptorclasses - сохранить классы встречающиеся в дескрипторе (что блять?)
# includecode - содержимое метода трогать тоже нельзя
# allowshrinking - можно удалить, если не используется, иначе нельзя даже трогать
# allowoptimization - можно оптимизировать, но нельзя удалять или абфусцировтаь
# allowobfuscation  - можно абфусцировать, но нельзя удалять или модифицировать

#опции помимо keep
# keepclassmembers - сохранить members, если класс сохранился после shrinking
# keepclasseswithmembers  - сохранить классы попадающие под шаблон
-keepclasseswithmembers class * {
    public <init> (android.content.Context);
}
# сохранит все классы, которые принимают в конструкторе один аргумент типа Context
#
# keepnames - сокращение для keep, allowshrinking
# keepclassmembersnames - сокращение для  -keepclassmembers,allowshrinking
# keepclasseswithmembernames - сокращение для -keepclasseswithmembers,allowshrinking.


# Работа с оптимизациями
-dontoptimize class com.helicoptera.proguard.person.DonOptimizePerson # ни одна оптимизация не будет выполнена
# модификации оптимизации будут проигнорированы
#
# Модификации оптимизации
-optimizations method/marking/synchronized
#
# optimizationpasses - Количество циклов оптимизации, если результат не улучшился с прошлого то прекращается
# Пример
-optimizationpasses 3
#
# -assumenosideeffects - Удаление вызовов чей результат не используется (ОСТОРОЖНО, УКАЗЫВАТЬ ТОЛЬКО ЕСЛИ МЕТОД НЕ
# ИМЕЕТ ПОБОЧНЫХ ЭФФЕКТОВ)
# Пример
-assumenosideeffects class android.util.Log { public static int d(...); }
#
# -allowaccessmodification - Показывает всё, что скрыто, позволяет избавиться от кучи ненужных методов (
# работает только с -repackageclasses)
#
#-repackageclasses — разрешает переместить все классы в один указанный пакет.
# Это больше относится к обфускации, но в то же время, дает хорошие результаты в оптимизации
#
