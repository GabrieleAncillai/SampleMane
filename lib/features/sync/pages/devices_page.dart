import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../models/local_identity.dart';
import '../../../models/paired_device.dart';
import '../../../models/remote_snapshot.dart';
import '../../../state/providers.dart';
import '../../../state/settings_controller.dart';
import '../device_certificate.dart';
import '../identity_service.dart';
import '../lan_server.dart';
import '../sync_service.dart';

class DevicesPage extends ConsumerWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final identity = ref.watch(identityProvider);
    final paired = ref.watch(pairedDevicesProvider).value ?? const <PairedDevice>[];

    return ManePage(
      title: l10n.devices,
      subtitle: l10n.devicesSubtitle,
      actions: [
        GlassIconButton(
          icon: Icons.refresh,
          tooltip: l10n.refreshDevices,
          onTap: () => ref.read(syncServiceProvider).refresh(),
        ),
      ],
      child: identity.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (value) {
          if (value == null) return _IdentitySetup(onCreated: () => ref.invalidate(identityProvider));
          return _DevicesBody(identity: value, devices: paired);
        },
      ),
    );
  }
}

class _IdentitySetup extends ConsumerStatefulWidget {
  const _IdentitySetup({required this.onCreated});

  final VoidCallback onCreated;

  @override
  ConsumerState<_IdentitySetup> createState() => _IdentitySetupState();
}

class _IdentitySetupState extends ConsumerState<_IdentitySetup> {
  late final TextEditingController _username;
  late final TextEditingController _deviceName;
  final _pin = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _deviceName = TextEditingController(text: IdentityService.defaultDeviceName());
  }

  @override
  void dispose() {
    _username.dispose();
    _deviceName.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(identityServiceProvider)
          .create(username: _username.text, deviceName: _deviceName.text, pin: _pin.text);
      widget.onCreated();
      await ref.read(serviceCoordinatorProvider).apply(ref.read(settingsProvider));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.identityCreated)));
      setState(() => _busy = false);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = '$error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        Text(l10n.pairingIdentity, style: ManeType.headline(20, color: context.mc.text)),
        const SizedBox(height: 6),
        Text(l10n.pairingIdentitySubtitle, style: ManeType.body(13, color: context.mc.textSecondary)),
        const SizedBox(height: 20),
        TextField(
          controller: _username,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.username, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _deviceName,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.deviceName, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _pin,
          obscureText: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l10n.pin,
            helperText: l10n.pinHint,
            border: const OutlineInputBorder(),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _busy ? null : _create,
          child: _busy
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(l10n.createIdentity),
        ),
      ],
    );
  }
}

class _DevicesBody extends ConsumerWidget {
  const _DevicesBody({required this.identity, required this.devices});

  final LocalIdentity identity;
  final List<PairedDevice> devices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sync = ref.watch(syncServiceProvider);
    return ValueListenableBuilder<SyncState>(
      valueListenable: sync.state,
      builder: (context, state, _) => ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          _IdentityCard(identity: identity, state: state),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(l10n.pairDevice, style: ManeType.title(16, color: context.mc.text)),
              ),
              FilledButton.tonalIcon(
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => const PairDevicePage())),
                icon: const Icon(Icons.add_link, size: 18),
                label: Text(l10n.pair),
              ),
            ],
          ),
          if (!state.discoveryAvailable && state.running)
            ManeNotice(text: l10n.discoveryUnavailable, tone: ManeNoticeTone.warning),
          const SizedBox(height: 12),
          if (devices.isEmpty)
            SoftCard(
              padding: EdgeInsets.zero,
              child: AppEmptyState(
                icon: Icons.devices_other_outlined,
                title: l10n.noPairedDevices,
                message: l10n.discoveryUnavailable,
                compact: true,
              ),
            )
          else
            for (final device in devices)
              _PairedDeviceCard(
                device: device,
                snapshot: state.snapshots[device.id],
                error: state.deviceErrors[device.id],
              ),
        ],
      ),
    );
  }
}

class _IdentityCard extends ConsumerWidget {
  const _IdentityCard({required this.identity, required this.state});

  final LocalIdentity identity;
  final SyncState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.mc;
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: c.accentSoft, borderRadius: BorderRadius.circular(11)),
                child: Icon(Icons.devices, size: 19, color: c.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.thisDevice, style: ManeType.label(10.5, color: c.textTertiary)),
                    Text(
                      '${identity.username} · ${identity.deviceName}',
                      style: ManeType.body(14, weight: FontWeight.w700, color: c.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${l10n.identityFingerprint}: ${shortFingerprint(fingerprintOfPemSync(identity.certificatePem))}',
            style: ManeType.body(11, color: c.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            state.running ? l10n.serverOnPort(state.port) : l10n.serverOff,
            style: ManeType.body(11, color: state.running ? c.success : c.textSecondary),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 4,
            children: [
              TextButton(onPressed: () => _editProfile(context, ref), child: Text(l10n.editIdentity)),
              TextButton(onPressed: () => _changePin(context, ref), child: Text(l10n.changePin)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _editProfile(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final username = TextEditingController(text: identity.username);
    final deviceName = TextEditingController(text: identity.deviceName);
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.editIdentity),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: username,
              decoration: InputDecoration(labelText: l10n.username),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: deviceName,
              decoration: InputDecoration(labelText: l10n.deviceName),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.save)),
        ],
      ),
    );
    if (saved == true) {
      await ref
          .read(identityServiceProvider)
          .updateProfile(identity, username: username.text, deviceName: deviceName.text);
      ref.invalidate(identityProvider);
      await ref.read(syncServiceProvider).restart();
      await ref.read(serviceCoordinatorProvider).apply(ref.read(settingsProvider));
    }
    username.dispose();
    deviceName.dispose();
  }

  Future<void> _changePin(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final current = TextEditingController();
    final next = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.changePin),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: current,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.currentPin),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: next,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.newPin, helperText: l10n.pinHint),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.save)),
        ],
      ),
    );
    if (saved == true) {
      final service = ref.read(identityServiceProvider);
      if (await service.verifyPin(identity, current.text)) {
        await service.changePin(identity, next.text);
        ref.invalidate(identityProvider);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pairingFailed(l10n.pin))));
      }
    }
    current.dispose();
    next.dispose();
  }
}

class _PairedDeviceCard extends ConsumerWidget {
  const _PairedDeviceCard({required this.device, this.snapshot, this.error});

  final PairedDevice device;
  final RemoteSnapshot? snapshot;
  final String? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.mc;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final lastSeen = device.lastSeenAt == null
        ? l10n.neverReached
        : l10n.lastSeen(DateFormat.yMMMd(locale).add_Hm().format(device.lastSeenAt!.toLocal()));

    return SoftCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: c.workSoft, borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.phone_android, size: 18, color: c.work),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  device.name,
                  style: ManeType.body(14, weight: FontWeight.w700, color: c.text),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GlassIconButton(
                icon: Icons.refresh,
                tooltip: l10n.refreshDevices,
                size: 32,
                onTap: () => ref.read(syncServiceProvider).refreshDevice(device.id),
              ),
              const SizedBox(width: 6),
              GlassIconButton(
                icon: Icons.link_off,
                tooltip: l10n.unpair,
                size: 32,
                onTap: () => _confirmUnpair(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${device.username} · ${device.host.isEmpty ? '' : '${device.host}:${device.port}'}',
            style: ManeType.body(11.5, color: c.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(lastSeen, style: ManeType.body(11, color: c.textTertiary)),
          if (error != null) ...[
            const SizedBox(height: 6),
            Text(error!, style: ManeType.body(11.5, color: c.danger)),
          ],
          if (snapshot != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.remoteToday(snapshot!.todayEntries.length, snapshot!.todayShifts.length),
              style: ManeType.body(12, color: c.text),
            ),
            if (snapshot!.nextShiftLabel != null)
              Text(
                l10n.remoteNextShift(snapshot!.nextShiftLabel!),
                style: ManeType.body(12, color: c.textSecondary),
              ),
            Text(
              l10n.remoteShopping(snapshot!.openShopping),
              style: ManeType.body(12, color: c.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmUnpair(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.unpairQuestion),
        content: Text(l10n.unpairBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.unpair)),
        ],
      ),
    );
    if (confirmed == true) await ref.read(syncServiceProvider).unpair(device.id);
  }
}

class PairDevicePage extends ConsumerStatefulWidget {
  const PairDevicePage({super.key});

  @override
  ConsumerState<PairDevicePage> createState() => _PairDevicePageState();
}

class _PairDevicePageState extends ConsumerState<PairDevicePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final identity = ref.watch(identityProvider).value;
    if (identity == null) {
      return ManePage(
        title: l10n.pairDevice,
        child: Center(child: Text(l10n.identityRequired)),
      );
    }
    return _PairTabs(identity: identity);
  }
}

class _PairTabs extends StatefulWidget {
  const _PairTabs({required this.identity});

  final LocalIdentity identity;

  @override
  State<_PairTabs> createState() => _PairTabsState();
}

class _PairTabsState extends State<_PairTabs> {
  bool _host = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ManePage(
      title: l10n.pairDevice,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ManeSegmented<bool>(
              segments: [
                ManeSegment(value: true, label: l10n.showPairingCode),
                ManeSegment(value: false, label: l10n.enterPairingCode),
              ],
              selected: _host,
              onChanged: (value) => setState(() => _host = value),
              compact: true,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: IndexedStack(
              index: _host ? 0 : 1,
              children: [
                _HostPairingTab(identity: widget.identity),
                const _GuestPairingTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HostPairingTab extends ConsumerStatefulWidget {
  const _HostPairingTab({required this.identity});

  final LocalIdentity identity;

  @override
  ConsumerState<_HostPairingTab> createState() => _HostPairingTabState();
}

class _HostPairingTabState extends ConsumerState<_HostPairingTab> {
  PairingSession? _session;
  String? _error;
  String? _pairedName;
  String _address = '';
  Timer? _ticker;
  StreamSubscription<PairedDevice>? _subscription;
  final _pin = TextEditingController();
  bool _unlocked = false;

  @override
  void initState() {
    super.initState();
    _loadAddress();
    _subscription = ref.read(syncServiceProvider).pairedEvents.listen((device) {
      if (!mounted) return;
      setState(() => _pairedName = device.name);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _subscription?.cancel();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _loadAddress() async {
    try {
      final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4, includeLoopback: false);
      final address = interfaces
          .expand((interface) => interface.addresses)
          .where((address) => !address.isLoopback)
          .map((address) => address.address)
          .toList();
      if (mounted) setState(() => _address = address.isEmpty ? '' : address.first);
    } on Object {
      if (mounted) setState(() => _address = '');
    }
  }

  Future<void> _unlock() async {
    final service = ref.read(identityServiceProvider);
    if (!await service.verifyPin(widget.identity, _pin.text)) {
      setState(() => _error = context.l10n.pairingFailed(context.l10n.pin));
      return;
    }
    setState(() {
      _unlocked = true;
      _error = null;
    });
    await _newCode();
  }

  Future<void> _newCode() async {
    try {
      final session = await ref.read(syncServiceProvider).beginPairing();
      if (!mounted) return;
      setState(() {
        _session = session;
        _pairedName = null;
        _error = null;
      });
      _ticker?.cancel();
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {});
      });
    } on Object catch (error) {
      if (mounted) setState(() => _error = '$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    if (!_unlocked) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.pinHint),
          const SizedBox(height: 12),
          TextField(
            controller: _pin,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.pin),
            onSubmitted: (_) => _unlock(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: 16),
          FilledButton(onPressed: _unlock, child: Text(l10n.showPairingCode)),
        ],
      );
    }

    final session = _session;
    final remaining = session == null ? 0 : session.expiresAt.difference(DateTime.now()).inSeconds;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (_pairedName != null) ...[
          Icon(Icons.check_circle_outline, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(l10n.pairingSucceeded(_pairedName!), style: theme.textTheme.titleMedium),
          const SizedBox(height: 20),
        ] else if (session != null && remaining > 0) ...[
          Text(l10n.pairingCode, style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(
            session.displayCode,
            style: theme.textTheme.displayMedium?.copyWith(letterSpacing: 8, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(l10n.pairingExpires),
          const SizedBox(height: 16),
          if (_address.isNotEmpty)
            SelectableText('$_address:${ref.read(syncServiceProvider).state.value.port}'),
          const SizedBox(height: 12),
          Text(l10n.pairingCodeHint),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: _newCode, child: Text(l10n.newCode)),
        ] else ...[
          Text(l10n.pairingExpires),
          const SizedBox(height: 12),
          FilledButton(onPressed: _newCode, child: Text(l10n.newCode)),
        ],
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
        ],
      ],
    );
  }
}

class _GuestPairingTab extends ConsumerStatefulWidget {
  const _GuestPairingTab();

  @override
  ConsumerState<_GuestPairingTab> createState() => _GuestPairingTabState();
}

class _GuestPairingTabState extends ConsumerState<_GuestPairingTab> {
  final _host = TextEditingController();
  final _port = TextEditingController();
  final _code = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _host.dispose();
    _port.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _pair() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final port = int.tryParse(_port.text.trim());
      if (port == null || port <= 0) throw const FormatException('Invalid port');
      final device = await ref
          .read(syncServiceProvider)
          .pairWithPeer(host: _host.text.trim(), port: port, code: _code.text.trim());
      ref.invalidate(identityProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.pairingSucceeded(device.name))));
      Navigator.of(context).pop();
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = error.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sync = ref.watch(syncServiceProvider);
    return ValueListenableBuilder<SyncState>(
      valueListenable: sync.state,
      builder: (context, state, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (state.discovered.isNotEmpty) ...[
            Text(l10n.discoveredOnNetwork, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            for (final peer in state.discovered)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.devices_other),
                title: Text('${peer.deviceName} · ${peer.username}'),
                subtitle: Text('${peer.host}:${peer.port}'),
                onTap: () => setState(() {
                  _host.text = peer.host;
                  _port.text = '${peer.port}';
                }),
              ),
            const SizedBox(height: 12),
          ] else
            Text(
              l10n.noDiscoveredDevices,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _host,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: l10n.address,
              hintText: l10n.hostHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _port,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.port, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _code,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.code, border: const OutlineInputBorder()),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _pair,
            child: _busy
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.pair),
          ),
        ],
      ),
    );
  }
}
