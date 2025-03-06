clear;
close all;

% Memasukkan gambar ke MATLAB
image = imread('image.jpg');

% Variabel-variabel yang digunakan
L = 256; % Jumlah maks level intensitas (8-bit = 256)
c = 1; % Konstanta c

% Besar konstanta gamma
gammaLight = 0.3; % Lebih kecil = lebih terang
gammaDark = 1.69;  % Lebih besar = lebih gelap

% Membuat gambar menjadi negatif
negativeImage = (L - 1) - image;

% Mengubah gamma dari gambar menjadi lebih terang dan gelap
imageDouble = double(image) / (L - 1);
imageLight = uint8(c * (imageDouble .^ gammaLight) * (L - 1)); % Lebih terang
imageDark = uint8(c * (imageDouble .^ gammaDark) * (L - 1));   % Lebih gelap

% Menampilkan gambar asli dan hasil-hasil perubahan
figure;
subplot(2,2,1), imshow(image), title('Gambar Asli');
subplot(2,2,2), imshow(negativeImage), title('Gambar Negatif');
subplot(2,2,3), imshow(imageLight), title('Gambar Terang');
subplot(2,2,4), imshow(imageDark), title('Gambar Gelap');