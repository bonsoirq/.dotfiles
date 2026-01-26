import os
import tomllib

from jinja2 import Environment, FileSystemLoader, StrictUndefined

CONFIG_FILE = "config.toml"
BASE_DIR = os.getcwd()  # dotfiles root


def load_config() -> dict:
    with open(CONFIG_FILE, "rb") as f:
        return tomllib.load(f)


def render_templates() -> None:
    context = load_config()

    env = Environment(
        loader=FileSystemLoader(BASE_DIR),
        undefined=StrictUndefined,
    )

    for root, _, files in os.walk(BASE_DIR):
        for filename in files:
            if not filename.endswith(".j2"):
                continue

            template_path = os.path.join(root, filename)
            rel_template_path = os.path.relpath(template_path, BASE_DIR)

            output_path = template_path.removesuffix(".j2")

            template = env.get_template(rel_template_path)
            rendered = template.render(**context)

            with open(output_path, "w") as f:
                f.write(rendered)

            print(f"Rendered {output_path}")


if __name__ == "__main__":
    render_templates()
