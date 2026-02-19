/*
===================================================
Membuat Database and Schemas
===================================================
Tujuan Script:
  Script ini membuat a sebuah database bernama 'DataWarehouse' setelah mengecek apakah database tersebut ada di dalam sistem atau tidak
  jika database ada di sistem, maka akan terDROP dan terCREATE ulang. Script ini terdiri dari tiga Schema 'bronze', 'silver' dan 'gold'.

WARNING:
  Menjalankan skrip ini akan mengDROP semua database "DataWarehouse" jika ada di sistem.
  Semua data akan terhapus permanen. 
  Lakukan dengan hati-hati dan pastikan Anda memiliki Backup Data sebelum menjalankan script ini
*/

USE MASTER;

-- DROP and reCREATE the "DataWarehouse" database
IF EXISTS (SELECT 1 FROM sys.databases WHERE NAME="DataWarehouse") -- Mengecek apakah ada database dengan nama DataWarehouse di server SQL.- sys.databases adalah sistem view yang berisi daftar semua database di instance SQL Server.
BEGIN -- BEGIN END -->  Digunakan untuk membungkus blok perintah yang akan dijalankan jika kondisi IF EXISTS benar.
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE; -- Mengubah status database menjadi SINGLE_USER mode → hanya satu koneksi yang bisa mengakses database.
  DROP DATABASE DataWarehouse; -- SELECT 1 digunakan untuk cek apakah ada atau tidak, jika ada akan mengembalikan nilai 1 tanpa ada nama kolom. ini lebih cepat karena tidak memakai * yang dapat membuat lama.
END;
GO

-- CREATE the "DataWarehouse" database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- CREATE SCHEMAS
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO

