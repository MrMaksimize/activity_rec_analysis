address <- "https://s3.amazonaws.com/coursera-uploads/user-00090fe7825e12f219d79c40/973501/asst-3/e885a8f0016011e589605504ec3ea316.txt"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE)
View(data)