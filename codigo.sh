<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Copias de Seguridad - Laboratorio</title>
  <style>
    body { font-family: sans-serif; background: #f8f8f8; padding: 2rem; }
    table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 0 8px #ccc; border-radius: 8px; overflow: hidden; }
    th, td { padding: 12px 16px; text-align: left; }
    th { background-color: #d2f3e6; }
    tr:nth-child(even) { background-color: #f2f2f2; }
    a { color: #1f8f4c; text-decoration: none; font-weight: bold; }
    a:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <h1>Copias de Seguridad - Laboratorio</h1>
  <table>
    <thead>
      <tr>
        <th>Equipo</th>
        <th>Último Backup</th>
        <th>Total de Archivos</th>
      </tr>
    </thead>
    <tbody>
      {% for e in equipos %}
      <tr>
        <td><a href="/ver/{{ e.nombre }}">{{ e.nombre }}</a></td>
        <td>{{ e.ultima_fecha }}</td>
        <td>{{ e.total }}</td>
      </tr>
      {% endfor %}
    </tbody>
  </table>
</body>
</html>
