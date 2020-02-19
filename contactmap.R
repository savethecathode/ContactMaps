#Usage (w/in R):> source("leoContactMap.R") 
#Usage command line: Rscript analysis.R infilename outfilename title segid segid 

# Import Methods library
library(methods)

# Get command-line argument
arg <- commandArgs(trailingOnly=TRUE) 

# Scan input file
M <- scan(file = arg[1]) # get infilename via commandline

# Construct matrix from file data
m <- matrix(M, nrow=length(M)/3, ncol=3, byrow=TRUE)

# Import Matrix library
library(Matrix)
# Populate and Set Dimensions of 'sparsematrix'
sM <- sparseMatrix(m[,1], m[,2], x=m[,3], dims=c(26,26))
m1 <- as.matrix(sM)

# Get amino-acid sequence from file
resid <- scan(file="amps.data", what=" ",comment.char="#")

# Set Output
#pdf("contactstest.pdf") # (orig/simple)
pdf(arg[2]) # get outfilename via commandline

# Import Lattice library
library(lattice)

my.palette=colorRampPalette(c("white","purple","blue","green","yellow","orange","red","brown"),space="rgb",bias=2.5)

print(levelplot(m1[1:ncol(m1),1:ncol(m1)],
	xlab=list(bquote(paste(.(arg[3]))),cex=0.8),
	ylab=list(bquote(paste(.(arg[4]))),cex=0.8),
	at=seq(0,2000,length=200),
        col.regions=my.palette(200),
        panel = function(...){
            panel.levelplot(...)
            panel.abline(h = c(1.5:26.5))
            panel.abline(v = c(1.5:26.5))
        },
        scales=list(x=list(at=seq(1,26,1),labels=resid,rot=90,cex=0.7),
		    y=list(at=seq(1,26,1),labels=resid,cex=0.7),
		    tck = c(1,0)),
	colorkey=list(labels=list(cex=0.65))
     )
)
dev.off()
