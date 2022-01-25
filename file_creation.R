# If the file doesn't already exist in the project directory,
# download from the SSA, manipulate, then write to .csv

if(!file.exists('bbynames.csv')){

  download.file(
    'https://www.ssa.gov/oact/babynames/names.zip',
    'names.zip'
  )

  unzip('names.zip', exdir = 'names')

  files <- dir_ls('names', regexp = r"(.txt$)")

  files |>
    map_dfr(~ read_csv(.x, col_names = FALSE), .id = 'source') |>
    rename(
      'name' = X1,
      'sex' = X2,
      'count' = X3) |>
    mutate(year = as.numeric(str_extract(source, r"(\d{4})"))) |>
    group_by(sex, year) |>
    mutate(prop = count / sum(count)) |>
    ungroup() |>
    select(name:prop) |>
    write_csv('bbynames.csv')

}


