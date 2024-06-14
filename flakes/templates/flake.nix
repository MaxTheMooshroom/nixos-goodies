{
  description = "Maxine's flake templates";

  outputs = { self, ... }: {
    templates = {
      zephyr = {
        path = ./zephyr;
        description = "Provide your current environment with the Zephyr SDK and various Zephyr dependencies";
      };
    };
  };
}
