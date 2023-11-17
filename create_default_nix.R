library(rix)

rix(r_ver = "4.3.1",
    r_pkgs = c("quarto", "chronicler", "targets", "tarchetypes"),
    system_pkgs = c("quarto"),
    tex_pkgs = c("amsmath", "framed", "fvextra",
                 "environ", "fontawesome5", "orcidlink",
                 "pdfcol", "tcolorbox", "tikzfill"),
    git_pkgs = list(package_name = "housing",
                    repo_url = "https://github.com/rap4all/housing",
                    branch_name = "fusen",
                    commit = "1c860959310b80e67c41f7bbdc3e84cef00df18e"),
    ide = "other",
    project_path = ".",
    overwrite = TRUE)
