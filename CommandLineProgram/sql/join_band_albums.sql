SELECT 
  b.id as band_id, 
  b.name as band_name, 
  a.id as album_id, 
  a.name as album_name, 
  a.position as album_chart_position 
  FROM Bands as b 
  JOIN Albums a 
  ON a.band_id=b.id;
