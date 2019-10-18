# Mariana Suarez and Jake Fry
# Project 1

#user inputs are as follows:
# $1 = first gene of choice
# $2 = second gene of choice
# $3 = the minimum number of hsp70 genes you are looking for 

#Join all mcrA reference sequences into a combined file
for file in ../ref_sequences/$1gene*.fasta; do cat $file >> $1gene_all.fasta; done             
# Join all hsp70gene reference sequences into a combined file
for file in ../ref_sequences/$2gene*.fasta; do cat $file >> $2gene_all.fasta; done    

    
# Apply muscle to combined mcrAgene and hsp70gene files
./muscle -in $1gene_all.fasta -out $1gene_all.afa       
./muscle -in $2gene_all.fasta -out $2gene_all.afa
  
# Apply hmmerbuild for both mcrAgene and hsp70gene
hmmer-3.2.1/bin/hmmbuild $1gene_all_out $1gene_all.afa  
hmmer-3.2.1/bin/hmmbuild $2gene_all_out $2gene_all.afa

# Apply hmmersearch on each group of genes  hspgene and mrcAgene
for file in proteome*
do 
hmmer-3.2.1/bin/hmmsearch --tblout $file.hsp $2gene_all_out $file 
hmmer-3.2.1/bin/hmmsearch --tblout $file.mcrA $1gene_all_out $file 
done

# Print the proteome number and its corresponding mcra and hsp70 gene hits

echo "proteome #, mcrAgene hits, hsp70gene hits" >> hits.txt

for i in {01..50}
do
a=$(cat proteome_$i.fasta.mcrA | grep -v "#" | wc -l)
b=$(cat proteome_$i.fasta.hsp | grep -v "#" | wc -l)
echo "$i, $a, $b" >> hits.txt

#print all candidates into a single file
cat hits.txt | tr "," " " | awk '(NR>1) && ($2 > 0) && ($3 >= '$3') ' >> candidates.txt


done
