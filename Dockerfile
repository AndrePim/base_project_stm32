# Базовый образ на основе Ubuntu 20.04
FROM ubuntu:22.04

# Устанавливаем необходимые зависимости
RUN apt-get update && apt-get install -y \
    gcc-arm-none-eabi \
    cmake \
    make \
    git \
    && rm -rf /var/lib/apt/lists/*

# Создаём рабочую директорию
WORKDIR /app

# Клонируем ваш проект
RUN git clone https://github.com/AndrePim/base_project_stm32.git .

# Клонируем STM32CubeF1 в /STM32CubeF1
RUN git clone https://github.com/STMicroelectronics/STM32CubeF1.git /STM32CubeF1

# Создаём директорию для сборки и выполняем сборку
RUN rm -f CMakeCache.txt && \
    mkdir -p build && cd build && cmake .. && make

# Команда по умолчанию
CMD ["make", "-C", "build"]