
import pandas as pd

# Ficheiro de entrada
INPUT_FILE = "stations_3.csv"

# Redes a analisar
# Acrescentar outras redes a esta lista
NETWORKS = [
    "Mobi.E",
    # "EDP",
    # "Tesla",
]


# Operadores a apresentar individualmente ou agrupados
OPERATOR_GROUPS = {
    "Galp + Mobiletric": ["Galp Power", "Galp Geste", "Mobiletric"],
    "EDP": ["EDP"],
    "Iberdrola | BP Pulse": ["Charging Together"],
    "Powerdot": ["Powerdot"],
    "Atlante": ["Atlante"],
    "Continente": ["Continente"],
    "wowplug": ["True Kare"],
    "Ionity": ["Ionity"],
    "Tesla": ["Tesla"],
    "Renewing + REMO":  ["Mota Engil II", "REMO"],   
    "Repsol": ["Repsol"],
    "Helexia": ["Helexia II"],
    "Prio": ["Prio.E"],
    "Telpark": ["Telpark"],
    "Cepsa / Moeve": ["Cepsa"],
    "Iberdrola": ["Iberdrola"],
    "Maksu": ["Maksu Services"],
    
    # Acrescentar outros operadores ou grupos
}





# Ler o CSV
df = pd.read_csv(INPUT_FILE, sep=",", dtype=str)

# Limpar nomes das colunas e valores
df.columns = df.columns.str.strip()

for col in df.columns:
    df[col] = df[col].str.strip()

# --------------------------------------------------
# 1. FILTROS GERAIS
# --------------------------------------------------

df = df[
    (df["flag_missing_tag"].str.lower() == "no") &
    (df["access"].str.lower().isin(["yes", "customers"])) &
    (df["type"].str.lower().isin(["way", "unassigned_point"]))
].copy()

# --------------------------------------------------
# 2. CONVERSÃO DE COLUNAS NUMÉRICAS
# --------------------------------------------------

numeric_cols = [
    "socket:chademo",
    "socket:type2_combo",
    "socket:tesla_destination",
    "socket:type2",
    "socket:type2_cable",
    "overflow",
    "adjusted_kw",
]

for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors="coerce").fillna(0)


# --------------------------------------------------
# 3. FUNÇÃO PARA CALCULAR OS SUMÁRIOS
# --------------------------------------------------

def calculate_summary(data):

    # Estações com DC
    mask_dc = (
        (data["socket:chademo"] != 0) |
        (data["socket:type2_combo"] != 0)
    )

    df_dc = data[mask_dc]

    pontos_dc = (
        df_dc["socket:chademo"] +
        df_dc["socket:type2_combo"] -
        df_dc["overflow"]
    ).sum()

    potencia_dc = df_dc["adjusted_kw"].sum()

    # Estações só AC
    mask_ac = (
        (data["socket:chademo"] == 0) &
        (data["socket:type2_combo"] == 0)
    )

    df_ac = data[mask_ac]

    pontos_ac = (
        df_ac["socket:tesla_destination"] +
        df_ac["socket:type2"] +
        df_ac["socket:type2_cable"] -
        df_ac["overflow"]
    ).sum()

    potencia_ac = df_ac["adjusted_kw"].sum()

    # Potência média por ponto
    media_dc = (
        potencia_dc / pontos_dc
        if pontos_dc != 0 else 0
    )

    media_ac = (
        potencia_ac / pontos_ac
        if pontos_ac != 0 else 0
    )

    return {
        "Registos": len(data),
        "Postos com DC": len(df_dc),
        "Pontos DC": pontos_dc,
        "Potência DC (kW)": potencia_dc,
        "Potência média DC (kW/ponto)": media_dc,
        "Postos só AC": len(df_ac),
        "Pontos AC": pontos_ac,
        "Potência AC (kW)": potencia_ac,
        "Potência média AC (kW/ponto)": media_ac,
    }


# --------------------------------------------------
# 4. CALCULAR E APRESENTAR OS RESULTADOS
# --------------------------------------------------

results = []

# Sumário global: todos os registos, independentemente da network
summary = calculate_summary(df)
summary["Network"] = "Todas as redes"
results.append(summary)


# Sumário: registos cuja network não contém "Mobi.E"
data_sem_mobie = df[
    ~df["network"].str.contains(
        "Mobi.E",
        case=False,
        na=False,
        regex=False
    )
].copy()

summary = calculate_summary(data_sem_mobie)
summary["Network"] = "Fora da Mobi.E"
results.append(summary)



# Sumários individuais por rede
for network in NETWORKS:

    data_network = df[
        df["network"].str.contains(
            network,
            case=False,
            na=False,
            regex=False
        )
    ].copy()

    summary = calculate_summary(data_network)
    summary["Network"] = network

    results.append(summary)

# Apresentar resultados numa tabela
if results:
    result_df = pd.DataFrame(results).set_index("Network")

    formatters = {
        "Pontos DC": "{:.0f}".format,
        "Pontos AC": "{:.0f}".format,
        "Potência DC (kW)": "{:.1f}".format,
        "Potência AC (kW)": "{:.1f}".format,
        "Potência média DC (kW/ponto)": "{:.1f}".format,
        "Potência média AC (kW/ponto)": "{:.1f}".format,
    }

    print("\nSUMÁRIOS POR NETWORK\n")
    print(result_df.to_string(formatters=formatters))

print("\n")
print(f"Total de registos após filtros gerais: {len(df)}")



# --------------------------------------------------
# 5. SUMÁRIOS POR OPERATOR, INDIVIDUAIS E AGRUPADOS
# --------------------------------------------------

results_operator = []

# Operadores e grupos definidos manualmente
for group_name, operators in OPERATOR_GROUPS.items():

    operators_normalized = [
        operator.casefold() for operator in operators
    ]

    data_operator = df[
        df["operator"].str.casefold().isin(operators_normalized)
    ].copy()

    summary = calculate_summary(data_operator)
    summary["Operator"] = group_name

    results_operator.append(summary)

# Agregar todos os operadores não incluídos nos grupos
all_grouped_operators = [
    operator.casefold()
    for operators in OPERATOR_GROUPS.values()
    for operator in operators
]

mask_outros = ~df["operator"].str.casefold().isin(
    all_grouped_operators
)

data_outros = df[mask_outros].copy()

summary_outros = calculate_summary(data_outros)
summary_outros["Operator"] = "Outros operadores"

results_operator.append(summary_outros)

# Apresentar resultados
result_operator_df = (
    pd.DataFrame(results_operator)
    .set_index("Operator")
)

print("\nSUMÁRIOS POR OPERATOR\n")
print(
    result_operator_df.to_string(
        formatters=formatters
    )
)



# --------------------------------------------------
# 6. EXPORTAR RESULTADOS PARA CSV
# --------------------------------------------------

# Sumários por Network
result_df.to_csv(
    "sumarios_network.csv",
    sep=";",
    decimal=",",
    encoding="utf-8-sig"
)

# Sumários por Operator
result_operator_df.to_csv(
    "sumarios_operator.csv",
    sep=";",
    decimal=",",
    encoding="utf-8-sig"
)

print("\n")
print("Ficheiros CSV criados:")
print("- sumarios_network.csv")
print("- sumarios_operator.csv")
