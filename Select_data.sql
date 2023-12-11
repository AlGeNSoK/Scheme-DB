--Задание 2
-- Вывод названия и продолжительности самого длинного трека
SELECT name, duration FROM Track
 ORDER BY duration DESC 
 LIMIT 1;

--Вывод списка треков с продолжительностью не менее 3,5 минут
SELECT name FROM Track 
 WHERE duration >= 210;
 
--Вывод списка сборников, вышедших с 2018 по 2020 год включительно
SELECT name FROM Collection 
 WHERE EXTRACT(YEAR FROM year_of_release) BETWEEN 2018 AND 2020;
 
--Список исполнителей, чьё имя состоит из одного слова
SELECT name FROM Artist 
 WHERE name NOT LIKE '% %';
 
--Названия треков, которые содержат слово "мой" или "my"
SELECT name FROM Track 
 WHERE name ILIKE 'my %' 
 	OR name ILIKE '% my %'
 	OR name ILIKE '% my'
 	OR name ILIKE 'my'
 	OR name ILIKE 'мой %'
 	OR name ILIKE '% мой %'
 	OR name ILIKE '% мой'
	OR name ILIKE 'мой';

--Дополнительный способ реализации через массивы
SELECT name FROM Track 
 WHERE STRING_TO_ARRAY(LOWER(name), ' ') && ARRAY['my', 'мой'];

--Дополнительный способ реализации через регулярные выражения
SELECT name FROM Track 
 WHERE LOWER(name) ~* '\mmy\M|\mмой\M';

 
--Задание 3
--Количество исполнителей в каждом жанре
SELECT g.name, COUNT(a.name) FROM Artist a
  JOIN ArtistGenre ag ON a.id = ag.artist_id
  JOIN Genre g ON ag.genre_id = g.id 
 GROUP BY g.name;

--Количество треков, вошедших в альбомы 2019-2020 годов
SELECT COUNT(t.name) FROM Album a
  JOIN Track t ON a.id = t.album_id
 WHERE EXTRACT(YEAR FROM a.year_of_release) BETWEEN 2019 AND 2020;

--Средняя продолжительность треков по каждому альбому
SELECT a.name, SUM(t.duration) / COUNT(t.name) avg_duration FROM Album a
  JOIN Track t ON a.id = t.album_id 
 GROUP BY a.name;

--Все исполнители, которые не выпустили альбомы в 2020 году
SELECT name FROM Artist 
 WHERE name NOT IN (SELECT Artist.name FROM Artist 
					  JOIN ArtistAlbum aa ON Artist.id = aa.artist_id
					  JOIN Album ON aa.album_id = Album.id 
					 WHERE EXTRACT(YEAR FROM Album.year_of_release) = 2020
					 GROUP BY Artist.name)

--Названия сборников, в которых присутствует конкретный исполнитель					 
SELECT c.name FROM Collection c
JOIN CollectionTrack ct ON c.id = ct.collection_id 
JOIN Track t ON ct.track_id = t.id 
JOIN Album a ON t.album_id = a.id 
JOIN ArtistAlbum aa ON a.id = aa.album_id 
JOIN Artist ON aa.artist_id = Artist.id 
WHERE Artist.name = 'Lady Gaga'
GROUP BY c.name;

--Задание 4
--Названия альбомов, в которых присутствуют исполнители более чем одного жанра
SELECT al.name FROM Album al
JOIN ArtistAlbum aa ON al.id = aa.album_id 
JOIN Artist a ON aa.artist_id = a.id 
JOIN ArtistGenre ag ON a.id = ag.artist_id 
GROUP BY al.name
HAVING COUNT(DISTINCT ag.genre_id) > 1 AND COUNT(DISTINCT a.id) > 1;


--Наименование треков, которые не входят в сборники
SELECT t.name FROM Track t
LEFT JOIN CollectionTrack ct ON t.id = ct.track_id 
WHERE ct.collection_id IS NULL;


--Исполнитель или исполнители, написавшие самый короткий по продолжительности трек
SELECT a.name FROM Artist a
JOIN ArtistAlbum aa ON a.id = aa.artist_id 
JOIN Album ON aa.album_id = Album.id 
JOIN Track t ON Album.id = t.album_id 
WHERE t.duration = (SELECT MIN(duration) FROM Track);



--Названия альбомов, содержащих наименьшее количество треков.
SELECT a.name FROM Album a
JOIN Track t ON a.id = t.album_id 
GROUP BY a.name
HAVING COUNT(t.name) = (SELECT COUNT(t.name)  FROM Album a
						  JOIN Track t ON a.id = t.album_id 
						 GROUP BY a.name
						 ORDER BY COUNT(t.name)
						 LIMIT 1);

