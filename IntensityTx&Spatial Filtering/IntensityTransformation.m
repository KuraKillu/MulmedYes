clear;
close all;

% Memasukkan gambar ke MATLAB
image = imread('image.jpg');

% Variabel-variabel yang digunakan
L = 256; % Jumlah maks level intensitas (8-bit = 256)
cGamma = 1; % Konstanta c untuk gamma transform (bernilai 1 untuk normalisasi)
cLog = 45; % Konstanta c untuk Log Transform (harus bernilai 0-255 karena gambar 8-bit)

% Besar konstanta gamma
gammaLight = 0.3; % Lebih kecil = lebih terang
gammaDark = 1.69;  % Lebih besar = lebih gelap

% Membuat gambar menjadi negatif
negativeImage = (L - 1) - image;

% Mengubah gamma dari gambar menjadi lebih terang dan gelap
imageGamma = double(image) / (L - 1);
imageLight = uint8(cGamma * (imageGamma .^ gammaLight) * (L - 1)); % Lebih terang
imageDark = uint8(cGamma * (imageGamma .^ gammaDark) * (L - 1));   % Lebih gelap

% Log Transform
imageLog = uint8(cLog * log(1 + double(image)));

% Menampilkan gambar asli dan hasil-hasil perubahan
figure; imshow(image); title('Gambar Asli');
figure; imshow(negativeImage); title('Gambar Negatif');
figure; imshow(imageLight); title('Gambar Terang');
figure; imshow(imageDark); title('Gambar Gelap');
figure; imshow(imageLog); title('Log Transform');