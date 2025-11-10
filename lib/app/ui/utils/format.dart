String formatCount(int count) {
  if (count >= 1000000) {
    double m = count / 1000000;
    return m.truncateToDouble() == m ? '${m.toStringAsFixed(0)}M' : '${m.toStringAsFixed(1)}M';
  } else if (count >= 1000) {
    double k = count / 1000;
    return k.truncateToDouble() == k ? '${k.toStringAsFixed(0)}k' : '${k.toStringAsFixed(1)}k';
  } else {
    return count.toString();
  }
}
