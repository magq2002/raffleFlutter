import 'package:flutter/material.dart';
import 'package:raffle/features/raffles/domain/entities/raffle.dart';
import 'package:raffle/features/raffles/domain/entities/ticket.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class BuyersListPage extends StatefulWidget {
  final Raffle raffle;
  final List<Ticket> tickets;

  const BuyersListPage({
    super.key,
    required this.raffle,
    required this.tickets,
  });

  @override
  State<BuyersListPage> createState() => _BuyersListPageState();
}

class _BuyersListPageState extends State<BuyersListPage> {
  String _searchQuery = '';
  String _statusFilter = 'all';
  List<Ticket> _filteredTickets = [];

  @override
  void initState() {
    super.initState();
    _filterTickets();
  }

  void _filterTickets() {
    _filteredTickets = widget.tickets.where((ticket) {
      if (ticket.buyerName == null) return false;
      
      final matchesSearch = ticket.buyerName!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ticket.buyerContact!.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesStatus = _statusFilter == 'all' || ticket.status == _statusFilter;
      
      return matchesSearch && matchesStatus;
    }).toList();
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy_HH-mm');
    return formatter.format(now);
  }

  String _getStatusInSpanish(String status) {
    switch (status) {
      case 'sold':
        return 'Vendido';
      case 'reserved':
        return 'Reservado';
      default:
        return status;
    }
  }

  Future<String> _getExportPath(String extension) async {
    final timestamp = _getFormattedDate();
    final fileName = 'compradores_${widget.raffle.name}_$timestamp.$extension'
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');

    if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/$fileName';
    } else {
      final directory = await getTemporaryDirectory();
      return '${directory.path}/$fileName';
    }
  }

  Future<void> _exportToPdf() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Lista de Compradores',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          widget.raffle.name,
                          style: const pw.TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Fecha: ${_getFormattedDate()}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Total boletas: ${_filteredTickets.length}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black),
                  ),
                  child: pw.Table.fromTextArray(
                    border: pw.TableBorder.all(color: PdfColors.black),
                    headerDecoration: pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    headerHeight: 25,
                    cellHeight: 40,
                    cellAlignments: {
                      0: pw.Alignment.center,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.centerLeft,
                      3: pw.Alignment.center,
                    },
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                    cellStyle: const pw.TextStyle(
                      fontSize: 10,
                    ),
                    headers: ['Número', 'Nombre', 'Contacto', 'Estado'],
                    data: _filteredTickets.map((ticket) => [
                      ticket.number.toString(),
                      ticket.buyerName ?? '',
                      ticket.buyerContact ?? '',
                      _getStatusInSpanish(ticket.status),
                    ]).toList(),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Resumen:',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Vendidas: ${_filteredTickets.where((t) => t.status == 'sold').length}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                        pw.Text(
                          'Reservadas: ${_filteredTickets.where((t) => t.status == 'reserved').length}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Valor total: \$${(widget.raffle.price * _filteredTickets.where((t) => t.status == 'sold').length).toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      final filePath = await _getExportPath('pdf');
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Lista de Compradores - ${widget.raffle.name}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar PDF: $e')),
        );
      }
    }
  }

  Future<void> _exportToExcel() async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Compradores'];

      // Encabezados
      final headers = ['Número', 'Nombre', 'Contacto', 'Estado'];
      for (var i = 0; i < headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = TextCellValue(headers[i]);
      }

      // Datos
      for (var i = 0; i < _filteredTickets.length; i++) {
        final ticket = _filteredTickets[i];
        final rowIndex = i + 1;

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = IntCellValue(ticket.number);

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = TextCellValue(ticket.buyerName ?? '');

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value = TextCellValue(ticket.buyerContact ?? '');

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          .value = TextCellValue(_getStatusInSpanish(ticket.status));
      }

      // Ajustar ancho de columnas
      sheet.setColumnWidth(0, 15);
      sheet.setColumnWidth(1, 30);
      sheet.setColumnWidth(2, 30);
      sheet.setColumnWidth(3, 20);

      final filePath = await _getExportPath('xlsx');
      final file = File(filePath);
      await file.writeAsBytes(excel.encode()!);
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Lista de Compradores - ${widget.raffle.name}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar Excel: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compradores'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.file_download),
            onSelected: (value) {
              if (value == 'pdf') {
                _exportToPdf();
              } else if (value == 'excel') {
                _exportToExcel();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pdf',
                child: Text('Exportar PDF'),
              ),
              const PopupMenuItem(
                value: 'excel',
                child: Text('Exportar Excel'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar por nombre o contacto',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _filterTickets();
                    });
                  },
                ),
                const SizedBox(height: 16),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'all',
                      label: Text('Todos'),
                    ),
                    ButtonSegment(
                      value: 'sold',
                      label: Text('Vendidos'),
                    ),
                    ButtonSegment(
                      value: 'reserved',
                      label: Text('Reservados'),
                    ),
                  ],
                  selected: {_statusFilter},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _statusFilter = newSelection.first;
                      _filterTickets();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTickets.length,
              itemBuilder: (context, index) {
                final ticket = _filteredTickets[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(ticket.number.toString()),
                  ),
                  title: Text(ticket.buyerName ?? ''),
                  subtitle: Text(ticket.buyerContact ?? ''),
                  trailing: Chip(
                    label: Text(
                      _getStatusInSpanish(ticket.status),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: ticket.status == 'sold'
                        ? Colors.green
                        : Colors.orange,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 