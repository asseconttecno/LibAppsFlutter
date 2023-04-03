
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ObrigacaoTipo
{
  Nenhum("Nenhum"),
  Impostos('Impostos'),
  Acessorias('Obr. Acessórias'),
  Relatorios('Relatórios'),
  Arquivos('Arquivos'),
  Solicitacoes('Solicitações'),
  Clientes('Obrigações de Clientes'),
  FolhaPagamento('Folha de Pagamento');

  final String value;

  IconData get icon {
    switch(value) {
      case "Nenhum":
        return Icons.request_quote_rounded;
        //return 'assets/imagens/taxes.png';
      case "Impostos":
        return Icons.request_quote_rounded;
        //return 'assets/imagens/taxes.png';
      case "Obr. Acessórias":
        return Icons.question_answer_rounded;
        //return 'assets/imagens/declaracao-de-renda.png';
      case "Relatórios":
        return Icons.receipt_rounded;
        //return 'assets/imagens/relatorio.png';
      case "Arquivos":
        return CupertinoIcons.arrow_down_doc_fill;
        //return 'assets/imagens/documento.png';
      case "Solicitações":
        return Icons.question_answer_rounded;
        //return 'assets/imagens/solicitacao.png';
      case "Obrigações de Clientes":
        return Icons.account_box_rounded;
        //return 'assets/imagens/cliente.png';
      case "Folha de Pagamento":
        return Icons.monetization_on_rounded;
        //return 'assets/imagens/folha-de-pagamento.png';
      default:
        return Icons.request_quote_rounded;
        //return 'assets/imagens/taxes.png';
    }
  }

  Color get cores {
    switch(value) {
      case "Nenhum":
        return Colors.blue;
      case "Impostos":
        return Colors.blue;
      case "Obr. Acessórias":
        return Colors.amber;
      case "Relatórios":
        return Colors.green;
      case "Arquivos":
        return Colors.brown;
      case "Solicitações":
        return Colors.red;
      case "Obrigações de Clientes":
        return Colors.orange;
      case "Folha de Pagamento":
        return Colors.yellow;
      default:
        return Colors.blue;
    }
  }

  ObrigacaoTipo get filtro {
    switch(value) {
      case "Nenhum":
        return Impostos;
      case "Impostos":
        return Impostos;
      case "Obr. Acessórias":
        return Acessorias;
      case "Relatórios":
        return Relatorios;
      case "Arquivos":
        return Impostos;
      case "Solicitações":
        return Solicitacoes;
      case "Obrigações de Clientes":
        return Impostos;
      case "Folha de Pagamento":
        return Impostos;
      default:
        return Impostos;
    }
  }

  static ObrigacaoTipo getEnum(String x) {
    switch(x.trim()) {
      case "Nenhum":
        return Nenhum;
      case "Impostos":
        return Impostos;
      case "Obr. Acessórias":
        return Acessorias;
      case "Relatórios":
        return Relatorios;
      case "Arquivos":
        return Arquivos;
      case "Solicitações":
        return Solicitacoes;
      case "Obrigações de Clientes":
        return Clientes;
      case "Folha de Pagamento":
        return FolhaPagamento;
      default:
        return Impostos;
    }
  }
  const ObrigacaoTipo(this.value);
}