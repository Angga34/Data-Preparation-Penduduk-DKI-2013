#import dataset
library(readxl)
dkikepadatankelurahan2013 <- read_excel("F:/MAKUL/Jangan Males Angga/DQ Lab/DQLab R/Dataset bagian 1/dkikepadatankelurahan2013.xlsx")
view(dkikepadatankelurahan2013)

#profiling
str(dkikepadatankelurahan2013)
summary(dkikepadatankelurahan2013)
names(dkikepadatankelurahan2013)

#mengganti nama
#names(dkikepadatankelurahan2013)[1]<-"Periode"
names(dkikepadatankelurahan2013)[37]<- ">75 Perempuan"

#merubah tipe kolom jadi factor (profiling lebih enak)
dkikepadatankelurahan2013$`NAMA PROVINSI`<-as.factor(dstrkikepadatankelurahan2013$`NAMA PROVINSI`)

#mengambil kolom tertentu
pola_perempuan<-grep(pattern = "perempuan", x = names(dkikepadatankelurahan2013), ignore.case = TRUE)
pola_laki<-grep(pattern = "laki-laki", x = names(dkikepadatankelurahan2013), ignore.case = TRUE)

#ngecek kolom yang diambil
names(dkikepadatankelurahan2013[pola_perempuan])
names(dkikepadatankelurahan2013[pola_laki])

#menambahkan kolom tertentu dan menjumlahkan isi kolom yang diambil tadi
dkikepadatankelurahan2013$Perempuan35TahunKeAtas<-rowSums(dkikepadatankelurahan2013[pola_perempuan])
dkikepadatankelurahan2013$Laki35TahunKeAtas<-rowSums(dkikepadatankelurahan2013[pola_laki])

#menghapus kolom
dkikepadatankelurahan2013[c(8:19)]<- NULL
#dkikepadatankelurahan2013[26:27]<- NULL

#merubah kolom ke baris reshape2
install.packages("reshape2")
library(reshape2)
pendki.transform <- melt(data=dkikepadatankelurahan2013,
                         id.vars=c( "TAHUN", "NAMA PROVINSI", "NAMA KABUPATEN/KOTA", "NAMA KECAMATAN", "NAMA KELURAHAN", "LUAS WILAYAH (KM2)", "KEPADATAN (JIWA/KM2)"),
                         measure.vars = c( "35-39 Laki-Laki","35-39 Perempuan","40-44 Laki-Laki", "40-44 Perempuan", "45-49 Laki-Laki", "45-49 Perempuan", "50-54 Laki-Laki", "50-54 Perempuan", "55-59 Laki-Laki", "55-59 Perempuan", "60-64 Laki-Laki", "60-64 Perempuan", "65-69 Laki-Laki", "65-69 Perempuan", "70-74 Laki-Laki", "70-74 Perempuan", ">75 Laki-Laki", ">75 Perempuan"),
                         variable.name = "DEMOGRAFIK", value.name="JUMLAH")

#spilt fields baris jadi kolom
pendki.transform[c("RENTANG UMUR", "JENIS KELAMIN")] <- colsplit(pendki.transform$DEMOGRAFIK," ",c("RENTANG UMUR","JENIS KELAMIN"))

write.csv(pendki.transform, file = "Hasil_PenDKI_Transform.csv ")