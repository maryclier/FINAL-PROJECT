import 'package:flutter/material.dart';

import '../services/music_service.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final MusicService _musicService = MusicService();

  int? _selectedIndex;
  bool _isPlaying = false;
  bool _isLoading = false;

  final List<Map<String, String>> _tracks = [
    {
      'title': 'Acoustic Sunrise',
      'artist': 'Alex Morgan',
      'mood': 'WARM & PEACEFUL',
      'file': 'alex-morgan-acoustic-guitar-sunrise-travel-573651.mp3',
    },
    {
      'title': 'Cozy Acoustic',
      'artist': 'Atlas Audio',
      'mood': 'COFFEE BREAK',
      'file': 'atlasaudio-acoustic-background-606210.mp3',
    },
    {
      'title': 'Piano Relaxation',
      'artist': 'Atlas Audio',
      'mood': 'CALM & FOCUSED',
      'file': 'atlasaudio-piano-relaxing-510242.mp3',
    },
    {
      'title': 'Little Daydream',
      'artist': 'Velario Music',
      'mood': 'SOFT & DREAMY',
      'file': 'velariomusic-piano-relaxing-606301.mp3',
    },
  ];

  Future<void> _toggleTrack(int index) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (_selectedIndex == index && _isPlaying) {
        await _musicService.pause();

        if (!mounted) return;
        setState(() => _isPlaying = false);
      } else if (_selectedIndex == index) {
        await _musicService.resume();

        if (!mounted) return;
        setState(() => _isPlaying = true);
      } else {
        await _musicService.play(_tracks[index]['file']!);

        if (!mounted) return;
        setState(() {
          _selectedIndex = index;
          _isPlaying = true;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to play audio: $e'),
          backgroundColor: const Color(0xFFA970D8),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _musicService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF463453),
      appBar: AppBar(
        title: const Text(
          'Music Corner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFA970D8), Color(0xFF724E84)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.headphones_rounded,
                  color: Color(0xFFFF9FD3),
                  size: 42,
                ),
                SizedBox(height: 18),
                Text(
                  'Press play.\nTake a breath.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'A little music for your coffee break.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'YOUR COZY PLAYLIST',
            style: TextStyle(
              color: Color(0xFFFF9FD3),
              letterSpacing: 2,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(_tracks.length, (index) {
            final track = _tracks[index];
            final selected = _selectedIndex == index;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF75548B)
                    : const Color(0xFF61466D),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFFF9FD3)
                      : const Color(0xFF7D5D8F),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA970D8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      index == 0
                          ? Icons.piano_rounded
                          : index == 1
                          ? Icons.coffee_rounded
                          : Icons.music_note_rounded,
                      color: const Color(0xFFFFC0E3),
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          track['artist']!,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          track['mood']!,
                          style: const TextStyle(
                            color: Color(0xFFFF9FD3),
                            fontSize: 10,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : () => _toggleTrack(index),
                    icon: Icon(
                      selected && _isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: const Color(0xFFFF9FD3),
                      size: 39,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          Text(
            _isLoading
                ? 'Loading your music...'
                : 'Your cozy playlist, ready whenever you need a break.',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
