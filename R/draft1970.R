data(Draft1970, package = "vcdExtra")

library(ggplot2)
library(lubridate)
# scatterplot
plot(Rank ~ Day, data=Draft1970)
with(Draft1970, lines(lowess(Day, Rank), col="red", lwd=2))
abline(lm(Rank ~ Day, data=Draft1970), col="blue")

# boxplots
plot(Rank ~ Month, data=Draft1970, col="bisque")

library(tidyverse)
data(Draft1970, package = "vcdExtra")
Draft1970 |> 
  arrange(Rank) |> 
  relocate(Rank) |>
  mutate(mday = lubridate::mday(as.Date(Day, origin="1971-12-31"))) |> 
  mutate(Date = paste(Month, mday, sep=" ")) |> head(8)




# find 15th of each month
#dates <- as.Date(0:365, origin = "1970-01-01")
#mid <- floor_date(ymd(dates), 'month') + days(15) |> unique()

# markers for months
months <- data.frame(
  month =unique(Draft1970$Month),
  mid = seq(15, 365-15, by = 30))

ggplot2:: theme_set(theme_bw(base_size = 16))
gg <- ggplot(Draft1970, aes(x = Day, y = Rank)) +
  geom_point(size = 2.5, shape = 21, 
             alpha = 0.3, 
             color = "black", 
             aes(fill=Month)
             ) +
  scale_fill_manual(values = rainbow(12)) +
  geom_text(data=months, aes(x=mid, y=0, label=month)) +
  geom_smooth(method = "lm", formula = y~1,
              col = "black", fill="grey", alpha=0.6) +
  labs(x = "Day of the year",
       y = "Lottery rank") +
  theme(legend.position = "none") 
gg

gg +  
  # geom_smooth(method = "loess", formula = y~x,
  #             fill="blue", alpha=0.25) +
      geom_smooth(method = "lm", formula = y~x,
                  color="darkgreen", alpha=0.25) 

# start over; make the points uncolored
gg2 <- ggplot(Draft1970, aes(x = Day, y = Rank)) +
  geom_point(size = 2.5, shape = 21, 
             alpha = 0.3, 
             color = "black", 
             fill = "brown"
  ) +
#  geom_text(data=months, aes(x=mid, y=0, label=month)) +
  geom_smooth(method = "lm", formula = y~1,
              se = FALSE,
              col = "black", fill="grey", alpha=0.6) +
  labs(x = "Day of the year",
       y = "Lottery rank") +
  theme(legend.position = "none") 
#gg2
gg2 +  
  geom_smooth(method = "loess", formula = y~x,
              color = "blue", se = FALSE,
              alpha=0.25) +
  geom_smooth(method = "lm", formula = y~x,
              color = "darkgreen",
              fill = "darkgreen", 
              alpha=0.25) 



draft.mod <- lm(Rank ~ Day, data=Draft1970)
anova(draft.mod)

# make the table version
Draft1970$Risk <- cut(Draft1970$Rank, breaks=3, labels=c("High", "Med", "Low"))
with(Draft1970, table(Month, Risk))