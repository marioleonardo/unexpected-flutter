import 'package:flutter/material.dart';
import 'package:pointz/data/models/point.dart';

class PointBottomSheet extends StatefulWidget {
  final Point point;
  final bool isFavorite;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;
  final VoidCallback onViewDetails;

  const PointBottomSheet({
    super.key,
    required this.point,
    required this.isFavorite,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFavorite,
    required this.onViewDetails,
  });

  @override
  State<PointBottomSheet> createState() => _PointBottomSheetState();
}

class _PointBottomSheetState extends State<PointBottomSheet> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onToggleFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.point.label,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: widget.onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: widget.onDelete,
              ),
              IconButton(
                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: widget.onViewDetails,
              ),
            ],
          ),
        ],
      ),
    );
  }
}