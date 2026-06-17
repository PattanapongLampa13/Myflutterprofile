import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _starController;
  late AnimationController _badgeController;
  late Animation<double> _badgeAnimation;

  // Profile info
  String _name = 'Patthanapong "Lucky" Lampa';
  String _title = 'Programer Of The West';
  String _bio =
      'A lone ranger riding through the dusty plains, chasing sunsets and rustling bandits like a bug. Known for the fastest Typing in the whole territory.';
  int _duelsWon = 47;
  int _milesRidden = 1200;
  int _bounties = 23;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _badgeAnimation = CurvedAnimation(
      parent: _badgeController,
      curve: Curves.elasticOut,
    );
    _badgeController.forward();
  }

  @override
  void dispose() {
    _starController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _profileImage = File(picked.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not pick image: $e'),
          backgroundColor: const Color(0xFF8B4513),
        ),
      );
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C1A0E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: Color(0xFFD4A017), width: 2)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A017),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '🤠  Choose Yer Photo',
                style: TextStyle(
                  color: Color(0xFFD4A017),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              _pickerOption(
                icon: Icons.camera_alt,
                label: 'Take a Photo',
                subtitle: 'Use the camera',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              _pickerOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                subtitle: 'Pick from your collection',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_profileImage != null)
                _pickerOption(
                  icon: Icons.delete_outline,
                  label: 'Remove Photo',
                  subtitle: 'Go back to default',
                  isDelete: true,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _profileImage = null);
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pickerOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    bool isDelete = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDelete
                  ? const Color(0xFF5C1A1A).withOpacity(0.5)
                  : const Color(0xFF3D2410).withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDelete
                    ? Colors.redAccent.withOpacity(0.5)
                    : const Color(0xFFD4A017).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDelete ? Colors.redAccent : const Color(0xFFD4A017),
                  size: 28,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: isDelete
                            ? Colors.redAccent
                            : const Color(0xFFF5DEB3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF8B7355),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0D05),
      body: CustomScrollView(
        slivers: [
          // ─── AppBar with Desert Gradient ───
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF2C1A0E),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFD4A017)),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFFD4A017)),
                onPressed: _showEditDialog,
                tooltip: 'Edit Profile',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(background: _buildHeroBackground()),
          ),

          // ─── Body Content ───
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildProfileSection(),
                const SizedBox(height: 24),
                _buildStatsRow(),
                const SizedBox(height: 24),
                _buildBioSection(),
                const SizedBox(height: 24),
                _buildSkillsSection(),
                const SizedBox(height: 24),
                _buildActionButtons(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Hero background with sunset/desert aesthetic ───
  Widget _buildHeroBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Sunset gradient sky
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D0805),
                Color(0xFF3B1A08),
                Color(0xFF7A3310),
                Color(0xFFB8520A),
                Color(0xFFD4A017),
              ],
              stops: [0.0, 0.2, 0.5, 0.75, 1.0],
            ),
          ),
        ),
        // Stars
        ...List.generate(12, (i) {
          final positions = [
            [0.05, 0.08],
            [0.15, 0.15],
            [0.25, 0.05],
            [0.35, 0.12],
            [0.45, 0.06],
            [0.55, 0.18],
            [0.65, 0.08],
            [0.75, 0.14],
            [0.85, 0.04],
            [0.92, 0.10],
            [0.10, 0.25],
            [0.80, 0.22],
          ];
          return Positioned(
            left: MediaQuery.of(context).size.width * positions[i][0],
            top: 280 * positions[i][1],
            child: AnimatedBuilder(
              animation: _starController,
              builder: (_, __) {
                final phase = (i * 0.3 + _starController.value * 2);
                final opacity = (0.4 + 0.6 * ((phase % 1.0))).clamp(0.3, 1.0);
                return Opacity(
                  opacity: opacity,
                  child: const Icon(
                    Icons.star,
                    color: Color(0xFFF5DEB3),
                    size: 6,
                  ),
                );
              },
            ),
          );
        }),
        // Mountain silhouette
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            painter: _MountainPainter(),
            size: const Size(double.infinity, 100),
          ),
        ),
        // Floating avatar in hero
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(child: _buildAvatarWidget()),
        ),
      ],
    );
  }

  // ─── Avatar with camera button ───
  Widget _buildAvatarWidget() {
    return GestureDetector(
      onTap: _showImagePickerDialog,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Outer glow ring
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFD4A017), Color(0xFF8B4513)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4A017).withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2C1A0E),
                ),
                child: ClipOval(
                  child: _profileImage != null
                      ? Image.file(
                          _profileImage!,
                          width: 122,
                          height: 122,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/image/_ChatGPT Image 5 ก.ย. 2568 17_51_21.jpg',
                          width: 122,
                          height: 122,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
          // Camera button overlay
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD4A017),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1A0D05), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Color(0xFF1A0D05),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Name + Title ───
  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            _name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFF5DEB3),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              shadows: [Shadow(color: Color(0xFFD4A017), blurRadius: 12)],
            ),
          ),
          const SizedBox(height: 8),
          // Badge / Title
          ScaleTransition(
            scale: _badgeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4A017), Color(0xFFB8860B)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4A017).withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⭐ ', style: TextStyle(fontSize: 14)),
                  Text(
                    _title.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF1A0D05),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text(' ⭐', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Stats: Duels Won, Miles Ridden, Bounties ───
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              icon: '🤠',
              value: '$_duelsWon',
              label: 'Duels Won',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              icon: '🐎',
              value: '$_milesRidden',
              label: 'Miles Ridden',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              icon: '💰',
              value: '$_bounties',
              label: 'Bounties',
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required String icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3D2410).withOpacity(0.9),
            const Color(0xFF2C1A0E).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4A017).withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFD4A017),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF8B7355), fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ─── Bio Section ───
  Widget _buildBioSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2C1A0E).withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD4A017).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A017),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'THE LEGEND',
                  style: TextStyle(
                    color: Color(0xFFD4A017),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _bio,
              style: const TextStyle(
                color: Color(0xFFF5DEB3),
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Skills Section ───
  Widget _buildSkillsSection() {
    final skills = [
      ('🎯 Quick Draw', 0.95),
      ('🐎 Horse Riding', 0.90),
      ('🔫 Marksmanship', 0.88),
      ('🃏 Poker', 0.75),
      ('🌵 Survival', 0.82),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2C1A0E).withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD4A017).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A017),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'COWBOY SKILLS',
                  style: TextStyle(
                    color: Color(0xFFD4A017),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...skills.map((skill) => _skillBar(skill.$1, skill.$2)),
          ],
        ),
      ),
    );
  }

  Widget _skillBar(String name, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFFF5DEB3),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: const TextStyle(
                  color: Color(0xFFD4A017),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: const Color(0xFF1A0D05),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFD4A017),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Action Buttons ───
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _actionBtn(
              label: 'Follow',
              icon: Icons.add,
              isPrimary: true,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _actionBtn(
              label: 'Message',
              icon: Icons.chat_bubble_outline,
              isPrimary: false,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [Color(0xFFD4A017), Color(0xFFB8860B)],
                )
              : null,
          color: isPrimary ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD4A017),
            width: isPrimary ? 0 : 1.5,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4A017).withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary
                  ? const Color(0xFF1A0D05)
                  : const Color(0xFFD4A017),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary
                    ? const Color(0xFF1A0D05)
                    : const Color(0xFFD4A017),
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Edit Profile Dialog ───
  void _showEditDialog() {
    final nameCtrl = TextEditingController(text: _name);
    final titleCtrl = TextEditingController(text: _title);
    final bioCtrl = TextEditingController(text: _bio);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF2C1A0E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🤠 Edit Profile',
                style: TextStyle(
                  color: Color(0xFFD4A017),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _editField('Name', nameCtrl),
              const SizedBox(height: 12),
              _editField('Title', titleCtrl),
              const SizedBox(height: 12),
              _editField('Bio', bioCtrl, maxLines: 3),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFF8B7355)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4A017),
                        foregroundColor: const Color(0xFF1A0D05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _name = nameCtrl.text;
                          _title = titleCtrl.text;
                          _bio = bioCtrl.text;
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editField(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(color: Color(0xFFF5DEB3)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF8B7355)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5C3A1E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD4A017)),
        ),
        filled: true,
        fillColor: const Color(0xFF1A0D05),
      ),
    );
  }
}

// ─── Mountain/Desert Silhouette Painter ───
class _MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0D0805)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.6);
    path.lineTo(size.width * 0.1, size.height * 0.3);
    path.lineTo(size.width * 0.2, size.height * 0.55);
    path.lineTo(size.width * 0.32, size.height * 0.2);
    path.lineTo(size.width * 0.42, size.height * 0.5);
    path.lineTo(size.width * 0.55, size.height * 0.1);
    path.lineTo(size.width * 0.65, size.height * 0.45);
    path.lineTo(size.width * 0.75, size.height * 0.25);
    path.lineTo(size.width * 0.85, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.35);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
