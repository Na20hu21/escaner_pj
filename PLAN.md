# Plan de implementación — app_poder_judicial

## Stack técnico
- **Estado**: `flutter_riverpod 3.x` + `riverpod_annotation 4.x` + `riverpod_generator 4.x`
- **Navegación**: `go_router 14.x` con `StatefulShellRoute` (tabs Notas / Destinatarios)
- **Modelos**: `freezed 3.x` + `json_serializable` (`abstract class` requerido en freezed 3)
- **Storage local**: `hive 2.x` + `hive_flutter` (JSON strings, sin TypeAdapters)
- **HTTP**: `dio`
- **Extras**: `uuid`, `shared_preferences`, `camera`, `image_picker`, `pdf`, `printing`, `share_plus`, `signature`, `permission_handler`, `intl`

## Arquitectura
Feature-First sin Clean Architecture:
```
lib/
├── core/          # transversal: theme, router, widgets, utils
└── features/
    ├── auth/
    ├── notes/
    ├── recipients/
    └── scanner/
```
Cada feature: `data/` · `providers/` · `screens/` · `widgets/`

## Notas técnicas importantes

- `freezed 3.x`: los modelos deben ser `abstract class Model with _$Model` (no `class`).
- `riverpod 3.x`: usar `asData?.value` en lugar de `valueOrNull` en `AsyncValue<T?>`.
- `@riverpod` code-gen: correr `dart run build_runner build --delete-conflicting-outputs` tras cada cambio de modelo o provider.
- `custom_lint` / `riverpod_lint` eliminados por incompatibilidad con `analyzer 7.x` (Dart 3.11.4).
- Splash screen: NO navegar desde `build()` con `ref.listen`. El router maneja toda la redirección via `_RouterNotifier` + `refreshListenable`.
- Router redirect: al estar en splash y auth ya resolvió → redirigir. NO hacer `if (isSplash) return null` sin verificar si auth terminó de cargar.

## Usuarios mock (Feature 1)
| Email | Password | Rol |
|---|---|---|
| `notificador@test.com` | `1234` | Notificador |
| `supervisor@test.com` | `1234` | Supervisor |

---

## Features MVP — estado de implementación

### ✅ Feature 1: Auth (mock)
**Done**: Login con email/password, sesión persistida en SharedPreferences, guard de rutas, roles enum.

Archivos clave:
- `features/auth/data/user.dart` — modelo `User` (freezed)
- `features/auth/data/user_role.dart` — enum `UserRole`
- `features/auth/data/auth_repository.dart` — interfaz + `AuthException`
- `features/auth/data/auth_repository_mock.dart` — mock con delay 500-800ms
- `features/auth/providers/auth_controller.dart` — `@riverpod AuthController` (AsyncNotifier)
- `features/auth/screens/login_screen.dart` — form real con loading/error
- `features/auth/screens/splash_screen.dart` — solo visual, router redirige
- `core/router/app_router.dart` — `_RouterNotifier` + `refreshListenable` + redirect

---

### ✅ Feature 2: Destinatarios (agenda)
**Done**: CRUD completo persistido en Hive, búsqueda por nombre/DNI, bottom nav con StatefulShellRoute.

Archivos clave:
- `features/recipients/data/recipient.dart` — modelo `Recipient` (freezed)
- `features/recipients/data/recipient_repository.dart` — interfaz
- `features/recipients/data/recipient_repository_impl.dart` — Hive (JSON strings)
- `features/recipients/providers/recipients_provider.dart` — lista, búsqueda, controller
- `features/recipients/screens/recipients_list_screen.dart` — lista + buscador + empty/error
- `features/recipients/screens/recipient_form_screen.dart` — crear/editar
- `features/recipients/screens/recipient_detail_screen.dart` — ver, editar, eliminar
- `core/widgets/home_shell.dart` — BottomNavigationBar
- `main.dart` — `Hive.initFlutter()`

---

### ✅ Feature 3: Scanner (captura + PDF)
**Pendiente**

Pasos:
1. Helper de permisos de cámara en `core/utils/permission_helper.dart`.
2. `ScannerScreen` con `camera` package — captura 1..N páginas.
3. Preview de páginas con opción de reordenar/eliminar.
4. Servicio `PdfBuilder` en `features/scanner/data/` — genera PDF desde imágenes.
5. Guardar PDF + miniatura en storage local (`path_provider`).
6. Retornar `CapturedDocument { pdfPath, thumbnailPath, pageCount }` al caller.

Done cuando: se puede capturar páginas y obtener un PDF guardado localmente.

---

### ✅ Feature 4: Notas (CRUD)
**Pendiente**

Pasos:
1. Modelo `Note` (id, recipientId, pdfPath, status: `NoteStatus`, createdAt, observations, history).
2. Enum `NoteStatus` { pendiente, entregada, noEntregada, rechazada }.
3. `NoteRepository` con Hive.
4. Providers: `notesListProvider`, `noteByIdProvider`, `notesByRecipientProvider`.
5. Flujo creación: Scanner → seleccionar destinatario → confirmar → guarda con estado `pendiente`.
6. `NotesListScreen`: lista real con filtros por estado, búsqueda, empty state.
7. `NoteDetailScreen`: PDF viewer, destinatario, estado, observaciones.

Done cuando: crear nota desde scanner, aparece en listado, se filtra y se ve el detalle.

---

### ✅ Feature 5: Estados + permisos
**Done**

Pasos:
1. Lista predefinida de motivos de rechazo (enum o constantes).
2. `PermissionGuard` helper: `canChangeNoteStatus(user, from, to)` según rol.
3. `NoteStatusController` provider: valida permiso → actualiza nota + agrega historial.
4. Botones de acción en `NoteDetailScreen` según estado actual y permisos.
5. Dialog "Rechazada" → selector de motivo obligatorio.
6. Dialog "No entregada" → observación opcional.
7. Dialog "Entregada" → dispara Feature 6.

Done cuando: cambio de estado respeta permisos y registra metadata.

---

### ✅ Feature 6: Confirmación de recepción (firma)
**Done**

Pasos:
1. Modelo `DeliveryReceipt` (signaturePngPath, receiverName, receiverDni, isThirdParty, capturedAt).
2. `DeliveryConfirmationScreen`: nombre receptor, DNI, checkbox "es tercero", pad de firma.
3. Al confirmar: guardar PNG firma, persistir `DeliveryReceipt` en nota, cambiar estado a `entregada`.
4. Mostrar recibo en detalle de nota.

Archivos clave:
- `features/notes/data/delivery_receipt.dart` — modelo `DeliveryReceipt` (freezed)
- `features/notes/screens/delivery_confirmation_screen.dart` — form + signature pad
- `features/notes/providers/notes_provider.dart` — método `confirmDelivery`
- `core/router/app_router.dart` — ruta `/home/notes/:id/delivery-confirmation`
- `features/notes/screens/note_detail_screen.dart` — navega a confirmación + muestra recibo

---

### ✅ Feature 7: Historial (audit trail completo)
**Done**

Archivos clave:
- `features/notes/data/note_history_entry.dart` — campos `editedAt`, `editedByName` para auditoría
- `features/notes/data/note_event.dart` — enum `NoteEvent` con todos los eventos
- `features/notes/data/permission_guard.dart` — `canEditHistory(user)` (solo supervisor)
- `features/notes/providers/notes_provider.dart` — método `editHistoryEntry`
- `features/notes/screens/note_detail_screen.dart` — timeline visual con líneas conectoras, botón editar (supervisor), `_HistoryEditDialog`

---

### ✅ Feature 8: PDF export / share
**Done**

Archivos clave:
- `features/notes/data/pdf_export_service.dart` — genera PDF con metadata (destinatario, estado, historial, firma)
- `features/notes/screens/note_detail_screen.dart` — `_ShareMenuButton` en AppBar con 3 opciones: compartir PDF original, compartir constancia, imprimir constancia

---

### ✅ Feature 9: Polish final
**Done**

Archivos clave:
- `core/widgets/loading_view.dart`, `error_view.dart`, `empty_view.dart` — widgets reutilizables
- `core/utils/app_snack_bar.dart` — helper `AppSnackBar.success/error`
- `notes_list_screen.dart`, `recipients_list_screen.dart`, `recipient_detail_screen.dart`, `note_detail_screen.dart` — usan widgets compartidos + AppSnackBar
- `recipient_form_screen.dart` — snackbar de éxito al crear/editar
- `note_detail_screen.dart` — tap target del botón editar historial corregido a 48dp + Semantics
- `test/features/notes/permission_guard_test.dart` — 14 tests de permisos por rol
- `test/features/notes/note_status_test.dart` — 4 tests de estados

Pendiente (manual): smoke test del flujo completo.

---

### Feature 10: Offline Queue (sync al recuperar señal)
**Done**

**Contexto**: Los notificadores trabajan en zonas sin internet. La entrega debe registrarse igual (GPS + timestamp + datos) y sincronizarse automáticamente cuando vuelva la señal.

**Paquetes a agregar en `pubspec.yaml`**:
- `connectivity_plus` — detectar cuando vuelve internet
- `workmanager` — intentar sync en background aunque la app esté cerrada
- `geolocator` — captura GPS offline (usa satélites, no necesita internet)

**Pasos**:
1. Modelo `PendingSyncEntry` (freezed): `{ id, noteId, lat, lng, capturedAt, retries, syncedAt? }`.
2. Box Hive `pending_sync` para persistir la cola localmente.
3. `SyncQueueRepository` — `enqueue`, `markSynced`, `getPending`, `incrementRetry`.
4. `ConnectivityService` (provider) — stream de `connectivity_plus`, expone `isOnline`.
5. `SyncQueueController` (riverpod) — escucha `ConnectivityService`; cuando `isOnline == true` procesa la cola y llama al endpoint (o mock por ahora).
6. En `DeliveryConfirmationScreen` — al confirmar entrega: capturar GPS con `geolocator`, encolar en `SyncQueueRepository`, mostrar banner "Entrega guardada, se sincronizará cuando tengas señal".
7. `workmanager` task `"sync_queue"` — registrar al iniciar la app; intenta procesar cola en background (best-effort).
8. Al abrir la app (`main.dart` o `SplashScreen`) — siempre intentar procesar pendientes si hay conexión.
9. `SyncStatusBanner` widget — mostrar en `HomeShell` si hay entradas pendientes: "📦 N entregas sin sincronizar".
10. Al sincronizar exitosamente → snackbar "✅ Entregas sincronizadas" + limpiar banner.

**Consideraciones**:
- Guardar `capturedAt` (hora real de entrega), no la hora de sincronización.
- iOS: `workmanager` en background no garantiza ejecución inmediata (puede demorar horas). No comunicar esto como "inmediato" al usuario.
- Android: algunos fabricantes (Xiaomi, Samsung) matan procesos. El sync al abrir la app es el mecanismo más confiable.
- No pedir al usuario que mantenga la app abierta — el banner les informa el estado.

Done cuando: registrar una entrega sin internet la encola, al volver la señal se sincroniza (automático o al abrir la app), y el banner refleja el estado real.

Archivos clave:
- `features/sync/data/pending_sync_entry.dart` — modelo `PendingSyncEntry` (freezed)
- `features/sync/data/sync_queue_repository.dart` — Hive box `pending_sync`
- `features/sync/providers/connectivity_service.dart` — `connectivityStreamProvider`, `isOnlineProvider`
- `features/sync/providers/sync_queue_controller.dart` — `SyncQueueController` (AsyncNotifier), auto-sync al recuperar señal
- `core/widgets/sync_status_banner.dart` — banner con conteo de pendientes
- `core/widgets/home_shell.dart` — muestra banner, procesa cola al abrir, snackbar al sincronizar
- `features/notes/screens/delivery_confirmation_screen.dart` — captura GPS + encola en `SyncQueueRepository`
- `main.dart` — inicializa workmanager con tarea periódica (15 min, solo con red)

---

## Fuera del MVP (no implementar salvo pedido)
- Sincronización con backend real (toda la data se guarda en local hasta que haya backend)
- Geolocalización automática fuera del flujo de entrega
- Métricas / dashboards
- Reportes avanzados
- iOS build
