% Kompresi audio dengan menggunakan DCT (Discrete Cosine Transform)

% Load file audio
[audio, fs] = audioread('StereoTest.wav'); %fs = frequency sampling

% Set parameters
segmentationLength = 0.1; % 100 ms
CR = 70; % Compression ratio (persentase koefisien yang dipertahankan)

% Membagi total panjang audio dengan panjang segmentasi lalu dibulatkan ke
% bawah untuk mendapatkan jumlah pembagian
windowLength = round(segmentationLength * fs); % panjang window
segmentationTotal = floor(length(audio) / windowLength);

% membuat array untuk audio compressed
audioCompressed = zeros(size(audio)); 

for z = 1:segmentationTotal
    % Menghitung indeks awal dan akhir dari segmentasi
    startIndex = (z - 1) * windowLength + 1;
    endIndex = startIndex + windowLength - 1;
    
    % Extract segmentasi audio sesuai start dan end index
    segmentedAudio = audio(startIndex:endIndex);
    
    % Menghitung DCT (Discrete Cosine Transform)
    coefDct = dctFormula(segmentedAudio);
    
    % Mengurutkan koefisien DCT dari paling kecil
    [sortedVals, sortedIndex] = sort(abs(coefDct), 'descend');
    
    % Menentukan koefisien DCT yang akan disimpan berdasarkan CR
    coefCr = round((CR / 100) * length(coefDct));
    
    % Membuat array baru untuk koefisien DCT yang telah dikompresi dengan hanya mempertahankan koefisien terbesar
    compressedDct = zeros(size(coefDct));
    compressedDct(sortedIndex(1:coefCr)) = coefDct(sortedIndex(1:coefCr));
    
    % Menghitung Inverse DCT
    signalNew = idctFormula(compressedDct);
    
    % Store in compressed audio
    audioCompressed(startIndex:endIndex) = signalNew;
end

% Normalisasi audio agar berada dalam rentang [-1, 1]
audioCompressed = audioCompressed / max(abs(audioCompressed));

% Save audio yang sudah dikompres
audiowrite('newTest.wav', audioCompressed, fs);

% Fungsi DCT
function y = dctFormula(x)
    N = length(x); % Panjang sinyal
    y = zeros(size(x)); % Inisialisasi output
   
    for k = 0:N-1
        % Hitung faktor normalisasi
        if k == 0
            a_k = sqrt(1/N);
        else
            a_k = sqrt(2/N);
        end
        
        % Hitung koefisien DCT
        sumVal = 0;
        for n = 0:N-1
            sumVal = sumVal + x(n+1) * cos((pi * (2*n + 1) * k) / (2*N));
        end
        y(k+1) = a_k * sumVal;
    end
end

% fungsi IDCT
function x = idctFormula(y)
    N = length(y); % Panjang koefisien DCT
    x = zeros(size(y)); % Inisialisasi output
    
    for n = 0:N-1
        sumVal = 0; % Inisialisasi nilai penjumlahan
        for k = 0:N-1
            % Hitung faktor normalisasi
            if k == 0
                a_k = sqrt(1/N);
            else
                a_k = sqrt(2/N);
            end
            
            % Hitung total dari setiap koefisien DCT
            sumVal = sumVal + a_k * y(k+1) * cos((pi * (2*n + 1) * k) / (2*N));
        end
        x(n+1) = sumVal; % Simpan hasil ke sinyal asli
    end
end