// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Mane';

  @override
  String get today => 'Hoy';

  @override
  String get week => 'Semana';

  @override
  String get calendar => 'Calendario';

  @override
  String get settings => 'Ajustes';

  @override
  String get tags => 'Etiquetas';

  @override
  String get shifts => 'Turnos';

  @override
  String get about => 'Acerca de';

  @override
  String get close => 'Cerrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get add => 'Añadir';

  @override
  String get edit => 'Editar';

  @override
  String get addEntry => 'Añadir una entrada';

  @override
  String get addSomething => 'Añadir algo';

  @override
  String get addOnThisDay => 'Añadir en este día';

  @override
  String get noPlanToday => 'No hay nada previsto para hoy.';

  @override
  String get noPlanTodayHint => 'No pasa nada. Si falta algo, añádelo ahora.';

  @override
  String get nothingPlanned => 'Nada previsto';

  @override
  String get shiftsSection => 'Turnos';

  @override
  String couldNotLoadDay(String error) {
    return 'No se pudo cargar tu día: $error';
  }

  @override
  String couldNotLoadShifts(String error) {
    return 'No se pudieron cargar los turnos: $error';
  }

  @override
  String get allDay => 'Todo el día';

  @override
  String get overnightSuffix => '(+1 día)';

  @override
  String get importedEvent => 'Evento de calendario importado';

  @override
  String get readOnlyNotice => 'Este evento viene de un calendario importado y es de solo lectura.';

  @override
  String get newEntry => 'Nueva entrada';

  @override
  String get editEntry => 'Editar entrada';

  @override
  String get titleQuestion => '¿Qué es?';

  @override
  String get titleRequired => 'Ponle un nombre';

  @override
  String get space => 'Espacio';

  @override
  String get type => 'Tipo';

  @override
  String get date => 'Fecha';

  @override
  String get starts => 'Empieza';

  @override
  String get ends => 'Termina';

  @override
  String get repeat => 'Repetir';

  @override
  String get repeatNever => 'Nunca';

  @override
  String get repeatDaily => 'Cada día';

  @override
  String get repeatWeekly => 'Cada semana';

  @override
  String get repeatMonthly => 'Cada mes';

  @override
  String get repeatYearly => 'Cada año';

  @override
  String get repeatAfterCompletion => 'Repetir al completar';

  @override
  String get repeatAfterCompletionSubtitle => 'Programa la siguiente desde el día que termines.';

  @override
  String get daysRequired => 'Usa un número de días mayor que cero.';

  @override
  String daysValue(int count) {
    return '$count días';
  }

  @override
  String get repeatAfterDaysLabel => 'Días entre tareas';

  @override
  String couldNotComplete(String error) {
    return 'No se pudo completar: $error';
  }

  @override
  String get notesOptional => 'Notas (opcional)';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get deleteEntryQuestion => '¿Eliminar esta entrada?';

  @override
  String get deleteEntryBody => 'Desaparecerá de tu plan.';

  @override
  String get endAfterStartError => 'La hora de fin tiene que ser posterior a la de inicio.';

  @override
  String couldNotSave(String error) {
    return 'No se pudo guardar: $error';
  }

  @override
  String couldNotDelete(String error) {
    return 'No se pudo eliminar: $error';
  }

  @override
  String timesDefinedIn(String timeZone) {
    return 'Las horas se definen en $timeZone';
  }

  @override
  String markAsDone(String title) {
    return 'Marcar $title como hecho';
  }

  @override
  String get entryKindTask => 'Tarea';

  @override
  String get entryKindEvent => 'Evento';

  @override
  String get entryKindObligation => 'Obligación';

  @override
  String get entryKindDeadline => 'Plazo';

  @override
  String get recurrenceEveryDay => 'Cada día';

  @override
  String recurrenceEveryNDays(int count) {
    return 'Cada $count días';
  }

  @override
  String get recurrenceEveryWeek => 'Cada semana';

  @override
  String recurrenceEveryNWeeks(int count) {
    return 'Cada $count semanas';
  }

  @override
  String recurrenceOnDays(String days) {
    return 'Cada semana los $days';
  }

  @override
  String recurrenceEveryNWeeksOnDays(int count, String days) {
    return 'Cada $count semanas los $days';
  }

  @override
  String get recurrenceEveryMonth => 'Cada mes';

  @override
  String recurrenceEveryNMonths(int count) {
    return 'Cada $count meses';
  }

  @override
  String recurrenceEveryNMonthsOnDay(int count, int day) {
    return 'Cada $count meses el día $day';
  }

  @override
  String recurrenceOnDayOfMonth(int day) {
    return 'Cada mes el día $day';
  }

  @override
  String get recurrenceEveryYear => 'Cada año';

  @override
  String recurrenceEveryNYears(int count) {
    return 'Cada $count años';
  }

  @override
  String get previousMonth => 'Mes anterior';

  @override
  String get nextMonth => 'Mes siguiente';

  @override
  String get previousWeek => 'Semana anterior';

  @override
  String get nextWeek => 'Semana siguiente';

  @override
  String get jumpToToday => 'Ir a hoy';

  @override
  String get monthView => 'Mes';

  @override
  String get weekView => 'Semana';

  @override
  String get selectedDay => 'Día seleccionado';

  @override
  String get noEntriesOnDay => 'No hay nada previsto este día.';

  @override
  String calendarDaySemantics(String date, int count) {
    return '$date, $count elementos';
  }

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Idioma del sistema';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get weekStartsOn => 'La semana empieza en';

  @override
  String get weekStartMonday => 'Lunes';

  @override
  String get weekStartSaturday => 'Sábado';

  @override
  String get weekStartSunday => 'Domingo';

  @override
  String get hideWorkSpace => 'Ocultar el espacio Trabajo';

  @override
  String get hideWorkSpaceSubtitle => 'Mantén el trabajo fuera de Hoy, Semana y Calendario.';

  @override
  String get defaultReminders => 'Recordatorios por defecto';

  @override
  String get defaultRemindersSubtitle => 'Se marcan al añadir una entrada.';

  @override
  String get reminderAtTime => 'A la hora de inicio';

  @override
  String reminderMinutesBefore(int count) {
    return '$count minutos antes';
  }

  @override
  String reminderHoursBefore(int count) {
    return '$count horas antes';
  }

  @override
  String reminderDaysBefore(int count) {
    return '$count días antes';
  }

  @override
  String get reminders => 'Recordatorios';

  @override
  String get addReminder => 'Añadir un recordatorio';

  @override
  String get removeReminder => 'Quitar recordatorio';

  @override
  String get remindersOff => 'Sin recordatorios';

  @override
  String get notificationPermissionDenied =>
      'Las notificaciones están desactivadas. Actívalas en los ajustes del sistema para que te lleguen los recordatorios.';

  @override
  String couldNotLoadReminders(String error) {
    return 'No se pudieron cargar los recordatorios: $error';
  }

  @override
  String get dataAndBackup => 'Datos y copia de seguridad';

  @override
  String get exportBackup => 'Exportar una copia';

  @override
  String get exportBackupSubtitle => 'Guarda un archivo JSON con todos tus datos.';

  @override
  String get importBackup => 'Importar una copia';

  @override
  String get importBackupSubtitle => 'Sustituye tus datos con una copia validada.';

  @override
  String get importCalendar => 'Importar un calendario';

  @override
  String get importCalendarSubtitle =>
      'Lee un archivo .ics local. Los eventos importados son de solo lectura.';

  @override
  String get importCalendarSpace => 'Importar en';

  @override
  String importCalendarDone(int imported, int updated, int skipped) {
    return '$imported importados, $updated actualizados y $skipped duplicados o no compatibles omitidos.';
  }

  @override
  String get importCalendarEmpty => 'No se han encontrado eventos en este archivo.';

  @override
  String importCalendarFailed(String error) {
    return 'La importación del calendario ha fallado: $error';
  }

  @override
  String get importCompanion => 'Importar una exportación de una app compañera';

  @override
  String get importCompanionSubtitle => 'Lee un horario JSON local exportado por otra app.';

  @override
  String importCompanionDone(int imported, int skipped) {
    return '$imported eventos importados. $skipped duplicados o filas no válidas omitidos.';
  }

  @override
  String get importCompanionEmpty => 'No se han encontrado eventos en este archivo.';

  @override
  String importCompanionFailed(String error) {
    return 'La importación de la app compañera ha fallado: $error';
  }

  @override
  String backupExported(String path) {
    return 'Copia guardada en $path';
  }

  @override
  String get backupImported => 'Copia restaurada.';

  @override
  String backupFailed(String error) {
    return 'Error de copia: $error';
  }

  @override
  String get backupInvalid => 'Este archivo no es una copia válida de Mane.';

  @override
  String get backupFuture => 'Esta copia viene de una versión más reciente de Mane.';

  @override
  String get importConfirmTitle => '¿Sustituir tus datos?';

  @override
  String get importConfirmBody =>
      'La copia sustituye todas las entradas, turnos, etiquetas y ajustes de este dispositivo.';

  @override
  String get syncAndAgent => 'Sincronización y agente local';

  @override
  String get syncEnabled => 'Sincronización LAN';

  @override
  String get syncOffInfo =>
      'Desactivada por defecto. Solo automática entre dispositivos vinculados en la misma red.';

  @override
  String get on => 'Activado';

  @override
  String get off => 'Desactivado';

  @override
  String get mcpEnabled => 'Endpoint MCP local';

  @override
  String get mcpOffInfo =>
      'Desactivado por defecto. Permite que un agente de escritorio lea el plan por loopback.';

  @override
  String get aboutSubtitle => 'Licencia, créditos y versión';

  @override
  String get appearanceSection => 'Apariencia';

  @override
  String get plannerSection => 'Planificador';

  @override
  String get librarySection => 'Biblioteca';

  @override
  String get privacySection => 'Privacidad';

  @override
  String get notSet => 'Ninguno';

  @override
  String selectedCount(int count) {
    return '$count seleccionados';
  }

  @override
  String get basedOnGymMane => 'Basado en GymMane de InlitX';

  @override
  String get basedOnStreak => 'Basado en Streak de InlitX';

  @override
  String get basedOnMane => 'Basado en Mane por los colaboradores de Mane';

  @override
  String version(String version) {
    return 'Versión $version';
  }

  @override
  String get license => 'Licencia';

  @override
  String get licenseBody =>
      'Mane es software libre bajo GPL-3.0-only. Se ofrece sin garantía. Consulta LICENSE y ADDITIONAL_TERMS.md en el repositorio.';

  @override
  String get credits => 'Créditos';

  @override
  String get creditsBody =>
      'Creado tomando como referencia GymMane y Streak de InlitX. Basado en Mane por los colaboradores de Mane.';

  @override
  String get tagsManager => 'Etiquetas';

  @override
  String get homeInventory => 'Inventario del hogar';

  @override
  String get homeInventorySubtitle => 'Cantidades, lugares y niveles de reposición.';

  @override
  String get shoppingList => 'Lista de la compra';

  @override
  String get shoppingListSubtitle => 'Comida y productos para la casa.';

  @override
  String get addHomeItem => 'Añadir un artículo';

  @override
  String get editHomeItem => 'Editar artículo';

  @override
  String get itemName => 'Artículo';

  @override
  String get category => 'Categoría';

  @override
  String get location => 'Lugar';

  @override
  String get quantity => 'Cantidad';

  @override
  String get unit => 'Unidad';

  @override
  String get reorderLevel => 'Reponer en';

  @override
  String get lowStock => 'Queda poco';

  @override
  String get inStock => 'Hay existencias';

  @override
  String get addToShoppingList => 'Añadir a la compra';

  @override
  String get addLowStockItems => 'Añadir artículos bajos';

  @override
  String get noLowStock => 'Nada está por debajo de su nivel de reposición.';

  @override
  String get homeInventoryEmpty => 'Todavía no hay artículos en casa.';

  @override
  String get shoppingListEmpty => 'La lista de la compra está vacía.';

  @override
  String get addShoppingItem => 'Añadir a la lista';

  @override
  String get editShoppingItem => 'Editar artículo de la lista';

  @override
  String get linkedItem => 'Artículo del inventario';

  @override
  String get noLink => 'Ninguno';

  @override
  String get note => 'Nota';

  @override
  String get archiveItemQuestion => '¿Archivar este artículo?';

  @override
  String get archiveItemBody => 'Desaparece del inventario pero se conserva en las copias.';

  @override
  String shoppingProgress(int done, int total) {
    return '$done de $total comprados';
  }

  @override
  String get sleepWindow => 'Ventana de sueño';

  @override
  String get sleepWindowSubtitle =>
      'Un bloque suave desde el último compromiso de hoy hasta el primero de mañana.';

  @override
  String get sleepBuffers => 'Márgenes de sueño';

  @override
  String sleepBuffersSummary(int commute, int windDown, int wake) {
    return '$commute desplazamiento · $windDown relax · $wake despertar';
  }

  @override
  String get commute => 'Desplazamiento (minutos)';

  @override
  String get windDown => 'Relax (minutos)';

  @override
  String get wakeBuffer => 'Margen al despertar (minutos)';

  @override
  String sleepBedtime(String time) {
    return 'Acostarse sobre las $time';
  }

  @override
  String sleepWake(String time) {
    return 'Despertar sobre las $time';
  }

  @override
  String get sleepWarning => 'Este plan deja poco margen para dormir.';

  @override
  String get sleepNoEarlyStart => 'Mañana no hay un inicio temprano.';

  @override
  String minutesValue(int count) {
    return '$count min';
  }

  @override
  String get tagsManagerSubtitle => 'Separa trabajos en Trabajo y personas o grupos en Personal.';

  @override
  String get shiftPatterns => 'Patrones de turnos';

  @override
  String get shiftPatternsSubtitle => 'Ciclos, tramos por día y excepciones de fecha.';

  @override
  String get addTag => 'Añadir una etiqueta';

  @override
  String get editTag => 'Editar etiqueta';

  @override
  String get tagName => 'Nombre';

  @override
  String get tagColor => 'Color';

  @override
  String get tagSpace => 'Espacio';

  @override
  String get tagSpaceAny => 'Cualquier espacio';

  @override
  String get noTags => 'Todavía no hay etiquetas.';

  @override
  String get deleteTagQuestion => '¿Eliminar esta etiqueta?';

  @override
  String get deleteTagBody => 'Se quitará de todas las entradas que la usen.';

  @override
  String get tagNameRequired => 'Ponle un nombre a la etiqueta.';

  @override
  String get manageTags => 'Gestionar etiquetas';

  @override
  String get filterByTag => 'Filtrar por etiqueta';

  @override
  String get clearFilters => 'Quitar filtros';

  @override
  String get newShiftPattern => 'Nuevo patrón de turnos';

  @override
  String get editShiftPattern => 'Editar patrón de turnos';

  @override
  String get patternName => 'Nombre del patrón';

  @override
  String get cycleLength => 'Duración del ciclo';

  @override
  String cycleLengthValue(int count) {
    return '$count días';
  }

  @override
  String get anchorDate => 'Fecha de inicio';

  @override
  String get timeZone => 'Zona horaria';

  @override
  String cycleDay(int index) {
    return 'Día $index';
  }

  @override
  String get addSlot => 'Añadir un tramo';

  @override
  String get removeSlot => 'Quitar tramo';

  @override
  String get slotLabel => 'Etiqueta';

  @override
  String get startTime => 'Inicio';

  @override
  String get endTime => 'Fin';

  @override
  String get exceptions => 'Excepciones de fecha';

  @override
  String get addException => 'Añadir excepción';

  @override
  String get exceptionFree => 'Día libre';

  @override
  String get exceptionOverride => 'Sustituir turnos';

  @override
  String get exceptionExtra => 'Turno extra';

  @override
  String get exceptionNote => 'Nota';

  @override
  String get exceptionDate => 'Fecha';

  @override
  String get preview => 'Próximos 28 días';

  @override
  String get conflictsFound => 'Algunos turnos se solapan. Corrígelos antes de guardar.';

  @override
  String get noConflicts => 'No hay turnos solapados.';

  @override
  String get savePattern => 'Guardar patrón';

  @override
  String get deletePatternQuestion => '¿Eliminar este patrón de turnos?';

  @override
  String get deletePatternBody => 'Sus turnos desaparecerán del calendario.';

  @override
  String get invalidTimeZone => 'Usa una zona IANA como Europe/Madrid.';

  @override
  String get patternNameRequired => 'Ponle un nombre al patrón.';

  @override
  String get noShiftPatterns => 'Todavía no hay patrones de turnos.';

  @override
  String get noSlots => 'No hay tramos en este día.';

  @override
  String get noExceptions => 'Sin excepciones.';

  @override
  String get shiftChecklist => 'Lista del turno';

  @override
  String get shiftChecklistSubtitle => 'Tareas para marcar en cada turno de este patrón.';

  @override
  String get addChecklistItem => 'Añadir tarea';

  @override
  String get checklistItemLabel => 'Tarea de la lista';

  @override
  String get noChecklistItems => 'Todavía no hay tareas.';

  @override
  String checklistDone(int done, int total) {
    return '$done de $total hechas';
  }

  @override
  String get devices => 'Dispositivos';

  @override
  String get devicesSubtitle => 'Empareja tus propios dispositivos por la red local.';

  @override
  String get thisDevice => 'Este dispositivo';

  @override
  String get pairingIdentity => 'Identidad de emparejamiento';

  @override
  String get pairingIdentitySubtitle => 'Un usuario y PIN locales. Nunca salen de aquí.';

  @override
  String get username => 'Usuario';

  @override
  String get deviceName => 'Nombre del dispositivo';

  @override
  String get pin => 'PIN';

  @override
  String get pinHint => 'Al menos cuatro dígitos.';

  @override
  String get createIdentity => 'Crear identidad';

  @override
  String get identityCreated => 'Identidad de emparejamiento creada.';

  @override
  String get editIdentity => 'Editar identidad';

  @override
  String get changePin => 'Cambiar PIN';

  @override
  String get currentPin => 'PIN actual';

  @override
  String get newPin => 'PIN nuevo';

  @override
  String get identityRequired => 'Configura un usuario y un PIN antes de emparejar.';

  @override
  String get pairDevice => 'Emparejar un dispositivo';

  @override
  String get showPairingCode => 'Mostrar un código en este dispositivo';

  @override
  String get enterPairingCode => 'Introducir un código de otro dispositivo';

  @override
  String get pairingCode => 'Código de emparejamiento';

  @override
  String get pairingCodeHint => 'En el otro dispositivo, elige «Introducir un código» y escribe este código.';

  @override
  String get pairingExpires => 'Válido durante cinco minutos.';

  @override
  String get newCode => 'Código nuevo';

  @override
  String pairingSucceeded(String name) {
    return 'Emparejado con $name.';
  }

  @override
  String pairingFailed(String error) {
    return 'El emparejamiento ha fallado: $error';
  }

  @override
  String get discoveredOnNetwork => 'Encontrados en esta red';

  @override
  String get noDiscoveredDevices => 'Todavía no se han encontrado otros dispositivos Mane.';

  @override
  String get address => 'Dirección';

  @override
  String get port => 'Puerto';

  @override
  String get code => 'Código';

  @override
  String get pair => 'Emparejar';

  @override
  String get pairedDevices => 'Dispositivos emparejados';

  @override
  String get noPairedDevices => 'Todavía no hay dispositivos emparejados.';

  @override
  String get unpair => 'Desemparejar';

  @override
  String get unpairQuestion => '¿Desemparejar este dispositivo?';

  @override
  String get unpairBody => 'Desaparece de este dispositivo. El otro conserva su propia copia.';

  @override
  String lastSeen(String time) {
    return 'Visto por última vez $time';
  }

  @override
  String get neverReached => 'Todavía sin conexión';

  @override
  String get refreshDevices => 'Actualizar';

  @override
  String remoteToday(int entries, int shifts) {
    return '$entries entradas y $shifts turnos hoy';
  }

  @override
  String remoteNextShift(String label) {
    return 'Próximo turno: $label';
  }

  @override
  String remoteShopping(int count) {
    return '$count artículos de compra pendientes';
  }

  @override
  String serverOnPort(int port) {
    return 'Servidor en el puerto $port';
  }

  @override
  String get serverOff => 'Servidor apagado';

  @override
  String get discoveryUnavailable =>
      'El descubrimiento en red no está disponible. Usa la dirección manualmente.';

  @override
  String get identityFingerprint => 'Huella del certificado';

  @override
  String get manualAddress => 'Dirección del dispositivo';

  @override
  String get hostHint => '192.168.1.20';

  @override
  String get mcpEndpoint => 'Endpoint MCP local';

  @override
  String get mcpEndpointSubtitle => 'Solo lectura por defecto, solo loopback y apagado salvo que lo actives.';

  @override
  String get mcpWriteTools => 'Permitir herramientas de escritura';

  @override
  String get mcpWriteToolsSubtitle => 'Deja que el agente local cree y complete entradas.';

  @override
  String get mcpToken => 'Token de acceso';

  @override
  String get mcpTokenHint => 'Úsalo como Bearer token. Al rotarlo se desconectan los agentes existentes.';

  @override
  String get rotateToken => 'Rotar token';

  @override
  String get copy => 'Copiar';

  @override
  String get copied => 'Copiado.';

  @override
  String get mcpLoopbackHint => 'Escucha solo en 127.0.0.1. El agente debe ejecutarse en esta máquina.';

  @override
  String mcpRunning(int port) {
    return 'Escuchando en 127.0.0.1:$port';
  }

  @override
  String get mcpStopped => 'El endpoint MCP está apagado.';

  @override
  String get search => 'Buscar';

  @override
  String get searchHint => 'Busca entradas, etiquetas y artículos del hogar';

  @override
  String get searchPrompt => 'Escribe un título, una nota, una etiqueta o un artículo del hogar.';

  @override
  String searchNoResults(String query) {
    return 'Nada coincide con «$query».';
  }

  @override
  String get searchEntries => 'Entradas';

  @override
  String get searchHomeItems => 'Artículos del hogar';

  @override
  String get nextShiftPrefix => 'Próximo: ';

  @override
  String get backupRestoredReminders => 'Los recordatorios se han vuelto a programar.';

  @override
  String get dayView => 'Día';

  @override
  String get shiftTags => 'Etiquetas del trabajo';

  @override
  String get commuteOverride => 'Tiempo de viaje propio';

  @override
  String get windDownOverride => 'Desconexión propia';

  @override
  String get inheritSleepBuffers => 'Déjalo vacío para usar los ajustes de sueño.';

  @override
  String get endDate => 'Termina el';

  @override
  String get multiDayHint => 'Deja la fecha final vacía para un solo día.';

  @override
  String get skipThisOccurrence => 'Omitir esta repetición';

  @override
  String get skippedOccurrences => 'Fechas omitidas';

  @override
  String get recurrenceExceptions => 'Excepciones';

  @override
  String get exportCalendar => 'Exportar calendario (.ics)';

  @override
  String get exportCalendarSubtitle => 'Comparte un archivo de solo lectura. Sin cuenta ni red.';

  @override
  String calendarExported(String path) {
    return 'Calendario exportado a $path';
  }

  @override
  String calendarExportFailed(String error) {
    return 'No se pudo exportar el calendario: $error';
  }

  @override
  String icsUpdated(int count) {
    return '$count actualizadas';
  }

  @override
  String get onlyThisOccurrence => 'Solo esta repetición';

  @override
  String get onlyThisOccurrenceSubtitle => 'Mantén la serie y cambia solo esta fecha.';

  @override
  String get singleDay => 'Un solo día';

  @override
  String get automaticBackups => 'Copias de seguridad locales automáticas';

  @override
  String get automaticBackupsSubtitle =>
      'Una copia JSON diaria en la carpeta de la app. Las copias antiguas se rotan.';

  @override
  String get keepBackups => 'Copias que conservar';

  @override
  String get exportCsv => 'Exportar CSV';

  @override
  String get exportCsvSubtitle => 'Entradas, compras o inventario.';

  @override
  String get importCsv => 'Importar CSV';

  @override
  String get importCsvSubtitle => 'Entradas, compras o inventario.';

  @override
  String get csvEntries => 'Entradas';

  @override
  String get csvShopping => 'Compras';

  @override
  String get csvInventory => 'Inventario';

  @override
  String csvExported(String path) {
    return 'CSV exportado a $path';
  }

  @override
  String csvExportFailed(String error) {
    return 'No se pudo exportar el CSV: $error';
  }

  @override
  String csvImportDone(int imported, int duplicates, int skipped) {
    return '$imported importadas, $duplicates duplicadas, $skipped omitidas';
  }

  @override
  String get csvImportEmpty => 'No hay filas que importar.';

  @override
  String get gymmaneImport => 'Horario de GymMane';

  @override
  String get gymmaneImportSubtitle =>
      'Bloques semanales de gimnasio de solo lectura desde un respaldo JSON de GymMane.';

  @override
  String gymmaneImportDone(int imported, int timed, int allDay, int skipped) {
    return '$imported bloques importados ($timed con hora, $allDay de todo el día), $skipped omitidos.';
  }

  @override
  String gymmaneImportFailed(String error) {
    return 'No se pudo importar GymMane: $error';
  }

  @override
  String get gymmaneImportEmpty => 'El respaldo no contiene un plan semanal.';

  @override
  String get appLock => 'Bloqueo de la app';

  @override
  String get appLockSubtitle => 'Pide un PIN al abrir la app.';

  @override
  String get appLockPinTitle => 'Elige un PIN';

  @override
  String get appLockPinRepeat => 'Repite el PIN';

  @override
  String get appLockPinMismatch => 'Los PIN no coinciden.';

  @override
  String get appLockUnlockTitle => 'Introduce tu PIN';

  @override
  String get appLockUnlockSubtitle => 'Desbloquea Mane';

  @override
  String get appLockWrong => 'PIN incorrecto. Inténtalo de nuevo.';

  @override
  String appLockLockedOut(int seconds) {
    return 'Demasiados intentos. Espera $seconds s.';
  }

  @override
  String get appLockEnabled => 'Bloqueo activado.';

  @override
  String get appLockDisabled => 'Bloqueo desactivado.';

  @override
  String get appLockPinLength => 'Usa de 4 a 8 dígitos.';

  @override
  String get purchaseHistory => 'Historial de compras';

  @override
  String get purchaseHistoryEmpty => 'Aún no hay compras registradas.';

  @override
  String get increaseQuantity => 'Aumentar cantidad';

  @override
  String get decreaseQuantity => 'Reducir cantidad';

  @override
  String lowStockCount(int count) {
    return '$count productos bajo el umbral';
  }

  @override
  String get maintenance => 'Mantenimiento';

  @override
  String get maintenanceSubtitle => 'Tareas que vencen después del último servicio.';

  @override
  String get maintenanceDue => 'Vence ahora';

  @override
  String get maintenanceUpcoming => 'Próximas';

  @override
  String get maintenanceNone => 'No hay tareas de mantenimiento.';

  @override
  String maintenanceDone(String date) {
    return 'Hecho. Próxima fecha: $date.';
  }

  @override
  String get clearChecked => 'Vaciar comprados';

  @override
  String get clearCheckedBody => '¿Eliminar todas las líneas compradas? No se puede deshacer.';

  @override
  String get shoppingToBuy => 'Por comprar';

  @override
  String get shoppingBought => 'Comprados';

  @override
  String get shoppingOther => 'Otros';

  @override
  String get moveUp => 'Subir';

  @override
  String get moveDown => 'Bajar';

  @override
  String get complete => 'Completar';
}
